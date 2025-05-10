import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PusherService {
  // Singleton
  static final PusherService _instance = PusherService._internal();
  factory PusherService() => _instance;

  // Instances
  PusherChannelsFlutter? _pusher;
  final Map<String, PusherChannel?> _channels = {};
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // États de connexion
  final ValueNotifier<PusherConnectionState> connectionState =
  ValueNotifier(PusherConnectionState.disconnected);

  PusherService._internal();

  // Initialisation sécurisée
  Future<void> init({
    String? appKey,
    String? cluster,
    bool enableLogging = kDebugMode,
  }) async {
    try {
      // Récupérer les clés de manière sécurisée
      appKey ??= await _secureStorage.read(key: '132bda35003d903c26a2')
          ?? PusherConfig.defaultAppKey;
      cluster ??= await _secureStorage.read(key: 'mt1')
          ?? PusherConfig.defaultCluster;

      _pusher = PusherChannelsFlutter.getInstance();

      await _pusher?.init(
        apiKey: appKey,
        cluster: cluster,
        onConnectionStateChange: (current, previous) {
          debugPrint('Pusher connection: $current from $previous');
          connectionState.value = _mapConnectionState(current);
        },
        onError: (message, code, error) {
          debugPrint('Pusher error: $message (Code: $code)');
          _handleConnectionError(message, code, error);
        },
      );

      await _pusher?.connect();
    } catch (e) {
      debugPrint('Erreur d\'initialisation Pusher : $e');
      _handleInitializationError(e);
      rethrow;
    }
  }

  // Méthodes de gestion des erreurs
  void _handleConnectionError(String message, int? code, dynamic error) {
    _secureStorage.write(
        key: 'PUSHER_CONNECTION_ERROR',
        value: '$message (Code: $code)'
    );
  }

  void _handleInitializationError(dynamic error) {
    _secureStorage.write(
        key: 'PUSHER_INIT_ERROR',
        value: error.toString()
    );
  }

  // Méthode générique d'écoute de canal
  Future<void> listenToChannel({
    required String channelName,
    required String eventName,
    required Function(dynamic) onReceive,
    Function(dynamic)? onError,
  }) async {
    try {
      if (_pusher == null) {
        throw Exception('Pusher non initialisé. Appelez init() d\'abord.');
      }

      // Vérifier si le canal existe déjà
      if (!_channels.containsKey(channelName)) {
        final channel = await _pusher?.subscribe(
          channelName: channelName,
          onEvent: (event) {
            if (event.eventName == eventName) {
              try {
                onReceive(event.data);
              } catch (e) {
                debugPrint('Erreur de traitement de l\'événement : $e');
                onError?.call(e);
              }
            }
          },
        );
        _channels[channelName] = channel;
      }
    } catch (e) {
      debugPrint('Erreur lors de l\'écoute du canal $channelName : $e');
      onError?.call(e);
    }
  }

  // Méthode pour écouter plusieurs canaux
  Future<void> listenToChannels({
    required List<String> channelNames,
    required String eventName,
    required Function(dynamic) onReceive,
    Function(dynamic)? onError,
  }) async {
    for (var channelName in channelNames) {
      await listenToChannel(
        channelName: channelName,
        eventName: eventName,
        onReceive: onReceive,
        onError: onError,
      );
    }
  }

  // Désabonnement de canaux
  Future<void> unsubscribeFromChannels(List<String> channelNames) async {
    if (_pusher == null) return;

    for (var channelName in channelNames) {
      try {
        await _pusher?.unsubscribe(channelName: channelName);
        _channels.remove(channelName);
      } catch (e) {
        debugPrint('Erreur lors du désabonnement du canal $channelName : $e');
      }
    }
  }

  // Configuration spécifique pour l'événement de réorientation
  Future<void> setupDemandeReorientationListeners({
    int? etudiantId,
    required Function(dynamic) onReceive,
    Function(dynamic)? onError,
  }) async {
    final channels = [
      'demandes-reorientation',
      if (etudiantId != null) 'etudiant-$etudiantId',
      'admin-notifications'
    ];

    await listenToChannels(
      channelNames: channels,
      eventName: 'DemandeReorientationEvent',
      onReceive: (data) {
        debugPrint('Événement de réorientation reçu : $data');
        onReceive(data);
      },
      onError: onError ?? (error) {
        debugPrint('Erreur de réception de l\'événement : $error');
      },
    );
  }

  // Déconnexion
  void disconnect() {
    try {
      _pusher?.disconnect();
      _channels.clear();
      connectionState.value = PusherConnectionState.disconnected;
    } catch (e) {
      debugPrint('Erreur lors de la déconnexion de Pusher : $e');
    }
  }

  // Méthodes utilitaires
  bool get isConnected => connectionState.value == PusherConnectionState.connected;

  void printChannelInfo() {
    debugPrint('Canaux Pusher actifs : ${_channels.keys}');
  }
}

// Configuration de Pusher
class PusherConfig {
  static const String defaultAppKey = '132bda35003d903c26a2';
  static const String defaultCluster = 'mt1';

  // Méthode pour stocker les identifiants de manière sécurisée
  static Future<void> storeCredentials({
    required String appKey,
    required String cluster
  }) async {
    final secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: 'PUSHER_APP_KEY', value: appKey);
    await secureStorage.write(key: 'PUSHER_CLUSTER', value: cluster);
  }
}
PusherConnectionState _mapConnectionState(String state) {
  switch (state.toLowerCase()) {
    case 'connected':
      return PusherConnectionState.connected;
    case 'disconnected':
      return PusherConnectionState.disconnected;
    case 'connecting':
      return PusherConnectionState.connecting;
    case 'reconnecting':
      return PusherConnectionState.reconnecting;
    default:
      return PusherConnectionState.error;
  }
}

// Énumération des états de connexion (pour plus de clarté)
enum PusherConnectionState {
  connected,
  disconnected,
  connecting,
  reconnecting,
  error
}

// Exemple d'utilisation
class PusherInitializer {
  static Future<void> initialize({
    required int etudiantId,
    required Function(dynamic) onDemandeReceived,
  }) async {
    final pusherService = PusherService();

    try {
      // Initialisation avec récupération sécurisée des identifiants
      await pusherService.init();

      // Configuration des canaux
      await pusherService.setupDemandeReorientationListeners(
        etudiantId: etudiantId,
        onReceive: (data) {
          onDemandeReceived(data);
        },
        onError: (error) {
          debugPrint('Erreur de réception Pusher : $error');
        },
      );
    } catch (e) {
      debugPrint('Erreur d\'initialisation de Pusher : $e');
    }
  }
}