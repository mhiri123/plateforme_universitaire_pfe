import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/auth_response.dart';
import '../../../models/demande_reorientation_model.dart';
import '../../../services/demande_reorientation_service.dart';
import '../../home/controllers/user_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DemandeReorientationController extends GetxController with StateMixin<List<DemandeReorientation>> {
  late final DemandeReorientationService _service;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<DemandeReorientation?> demandeCourante = Rx<DemandeReorientation?>(null);
  final RxList<DemandeReorientation> mesDemandesReorientation = <DemandeReorientation>[].obs;
  final RxList<DemandeReorientation> demandesEnAttente = <DemandeReorientation>[].obs;
  late final UserController userController;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Controllers for editable fields
  late TextEditingController nomController;
  late TextEditingController prenomController;
  late TextEditingController filiereActuelleController;
  late TextEditingController niveauController;
  late TextEditingController faculteController;
  late TextEditingController nouvelleFiliereController;
  late TextEditingController motivationController;

  @override
  void onInit() {
    super.onInit();
    print('\n=== DÉBUT INITIALISATION DemandeReorientationController ===');
    try {
      _service = Get.find<DemandeReorientationService>();
      print('✓ Service trouvé avec succès');
      
      // Initialiser le UserController
      userController = Get.put(UserController());
      print('✓ UserController initialisé avec succès');
      
      // Vérifier le token d'authentification
      _checkAuthToken();
      
      // Initialiser les contrôleurs avec des valeurs vides
      _initializeEmptyControllers();
      print('✓ Contrôleurs initialisés avec des valeurs vides');
      
      // Vérifier le stockage local
      _checkLocalStorage();
      
      _loadUserData();
      _chargerDonnees();
      print('\n=== FIN INITIALISATION DemandeReorientationController ===\n');
    } catch (e) {
      print('❌ ERREUR dans onInit: $e');
      print('Stack trace: ${StackTrace.current}');
      // Afficher une notification d'erreur à l'utilisateur
      _showErrorNotification('Erreur lors de l\'initialisation: $e');
    }
  }

  Future<void> _checkAuthToken() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      print("Token récupéré : $token");
      
      if (token == null || token.isEmpty) {
        print('❌ Token d\'authentification manquant');
        Get.offAllNamed('/login');
        return;
      }
      print('✓ Token d\'authentification trouvé');
    } catch (e) {
      print('❌ Erreur lors de la vérification du token : $e');
      Get.offAllNamed('/login');
    }
  }

  void _checkLocalStorage() {
    final box = GetStorage();
    print('\n=== DONNÉES DANS LE STOCKAGE ===');
    print('userId: ${box.read('userId')?.toString()}');
    print('userName: ${box.read('userName')?.toString()}');
    print('userRole: ${box.read('userRole')?.toString()}');
    print('userEmail: ${box.read('userEmail')?.toString()}');
  }

  void _initializeEmptyControllers() {
    print('Initialisation des contrôleurs avec des valeurs vides');
    nomController = TextEditingController();
    prenomController = TextEditingController();
    filiereActuelleController = TextEditingController();
    niveauController = TextEditingController();
    faculteController = TextEditingController();
    nouvelleFiliereController = TextEditingController();
    motivationController = TextEditingController();
  }

  void _loadUserData() {
    print('\n=== CHARGEMENT DES DONNÉES UTILISATEUR ===');
    try {
      print('État du UserController:');
      print('Email: ${userController.userEmail.value}');
      print('Rôle: ${userController.userRole.value}');
      
      if (userController.utilisateurConnecte.value != null) {
        print('✓ Données utilisateur disponibles dans le UserController');
        _updateControllersWithUserData();
      } else {
        print('⚠ Données utilisateur non disponibles, tentative de chargement...');
        final box = GetStorage();
        final userId = box.read('userId')?.toString();
        final userRole = box.read('userRole')?.toString();
        final userEmail = box.read('userEmail')?.toString();
        
        if (userId != null && userRole != null && userEmail != null && userEmail.isNotEmpty) {
          print('\nTentative de chargement des données utilisateur...');
          userController.setUser(
            userEmail,
            userRole,
            int.tryParse(userId) ?? 0
          ).then((_) {
            print('\n✓ Données utilisateur chargées avec succès');
            _updateControllersWithUserData();
          }).catchError((error) {
            print('❌ Erreur lors du chargement: $error');
            Get.offAllNamed('/login');
          });
        } else {
          print('❌ Données utilisateur incomplètes dans le stockage');
          Get.offAllNamed('/login');
        }
      }
    } catch (e) {
      print('❌ Erreur lors du chargement: $e');
      Get.offAllNamed('/login');
    }
  }

  void _updateControllersWithUserData() {
    print('\n=== MISE À JOUR DES CONTRÔLEURS ===');
    try {
      if (userController.utilisateurConnecte.value == null) {
        print('❌ Utilisateur non connecté');
        return;
      }

      // Récupération des données de l'utilisateur
      final user = userController.utilisateurConnecte.value!;
      
      // Mise à jour des contrôleurs avec les données de l'utilisateur
      nomController.text = user.nom ?? '';
      prenomController.text = user.prenom ?? '';
      filiereActuelleController.text = user.filiere ?? '';
      niveauController.text = user.niveau?.toString() ?? '';
      faculteController.text = userController.getFaculte() ?? '';

      print('\nVérification des valeurs:');
      print('Nom: ${nomController.text}');
      print('Prénom: ${prenomController.text}');
      print('Filière: ${filiereActuelleController.text}');
      print('Niveau: ${niveauController.text}');
      print('Faculté: ${faculteController.text}');
      
      update();
      print('\n✓ Interface mise à jour avec succès');
    } catch (e) {
      print('❌ Erreur lors de la mise à jour: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  @override
  void onReady() {
    super.onReady();
    print('DemandeReorientationController - onReady démarré');
    _loadUserData();
  }

  @override
  void onClose() {
    nomController.dispose();
    prenomController.dispose();
    filiereActuelleController.dispose();
    niveauController.dispose();
    faculteController.dispose();
    nouvelleFiliereController.dispose();
    motivationController.dispose();
    super.onClose();
  }

  Future<void> _chargerDonnees() async {
    await Future.wait([
      chargerDemandesEnAttente(),
      chargerMesDemandesReorientation(),
    ]);
  }

  Future<void> soumettreDemandeReorientation({
    required String nouvelleFiliere,
    required String motivation,
    File? pieceJustificative,
  }) async {
    print('Début de soumettreDemandeReorientation');
    try {
      final nom = nomController.text;
      final prenom = prenomController.text;
      final filiereActuelle = filiereActuelleController.text;
      final niveau = niveauController.text;
      final faculte = faculteController.text;

      print('Données du formulaire:');
      print('Nom: $nom');
      print('Prénom: $prenom');
      print('Filière actuelle: $filiereActuelle');
      print('Nouvelle filière: $nouvelleFiliere');
      print('Niveau: $niveau');
      print('Faculté: $faculte');
      print('Motivation: $motivation');

      final validationResult = _validateDonnees(
        nom: nom,
        prenom: prenom,
        filiereActuelle: filiereActuelle,
        choixNouvelleFiliere: nouvelleFiliere,
        motivation: motivation,
        level: niveau,
        facultyName: faculte,
        pieceJustificative: pieceJustificative,
      );

      if (!validationResult.isValid) {
        print('Erreurs de validation: ${validationResult.errors.join(', ')}');
        _showErrorNotification(validationResult.errors.join('\n'));
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';

      print('Envoi de la demande au service...');
      final result = await _service.soumettreDemande(
        nom: nom,
        prenom: prenom,
        filiereActuelleNom: filiereActuelle,
        nouvelleFiliereNom: nouvelleFiliere,
        motivation: motivation,
        level: niveau,
        facultyName: faculte,
        pieceJustificative: pieceJustificative,
      );

      print('Demande soumise avec succès: ${result.id}');
      demandeCourante.value = result;
      mesDemandesReorientation.add(result);
      demandesEnAttente.add(result);

      _showSuccessNotification("Demande soumise avec succès");
      _resetForm();
      
      // Actualiser la liste des demandes
      await chargerMesDemandesReorientation();
    } catch (e, stackTrace) {
      print('Erreur lors de la soumission: $e');
      print('Stack trace: $stackTrace');
      errorMessage.value = e.toString();
      _showErrorNotification(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  void _resetForm() {
    print('Début de la réinitialisation du formulaire');
    try {
      nomController.text = userController.getNom();
      prenomController.text = userController.getPrenom();
      filiereActuelleController.text = userController.getFiliere();
      niveauController.text = userController.getNiveauLibelle();
      faculteController.text = userController.getFaculte();
      nouvelleFiliereController.clear();
      motivationController.clear();
      update();
      print('Formulaire réinitialisé avec succès');
    } catch (e) {
      print('Erreur lors de la réinitialisation du formulaire: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> chargerDemandesEnAttente() async {
    try {
      change(null, status: RxStatus.loading());

      final demandes = await _service.listerDemandesEnAttente();
      demandesEnAttente.value = demandes;

      change(demandes, status: RxStatus.success());
    } catch (e) {
      errorMessage.value = e.toString();
      change(null, status: RxStatus.error(e.toString()));
      _showErrorNotification(errorMessage.value);
    }
  }

  Future<void> chargerMesDemandesReorientation() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Récupérer l'ID de l'utilisateur connecté
      final userId = await _getIdEtudiantConnecte();
      if (userId == null) {
        throw Exception('ID utilisateur non trouvé');
      }

      final demandes = await _service.listerMesDemandesReorientation(userId);
      mesDemandesReorientation.value = demandes;
    } catch (e) {
      print('❌ Erreur lors du chargement des demandes: $e');
      errorMessage.value = e.toString();
      _showErrorNotification(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<int?> _getIdEtudiantConnecte() async {
    try {
      final box = GetStorage();
      final userId = box.read('userId');
      if (userId == null) {
        print('⚠️ ID utilisateur non trouvé dans le stockage');
        return null;
      }
      return int.tryParse(userId.toString());
    } catch (e) {
      print('❌ Erreur lors de la récupération de l\'ID utilisateur: $e');
      return null;
    }
  }

  Future<void> traiterDemandeReorientation(int demandeId, bool accepter) async {
    try {
      final result = await _service.traiterDemande(
        demande: DemandeReorientation(
          id: demandeId,
          nom: '',
          prenom: '',
          filiereActuelleNom: '',
          nouvelleFiliereNom: '',
          motivation: '',
          level: '',
          facultyName: '',
          statut: accepter ? StatutDemande.acceptee : StatutDemande.rejetee,
        ),
        isAccepted: accepter,
        commentaire: accepter ? "Votre demande a été acceptée." : "Votre demande a été rejetée.",
      );

      if (result != null) {
        Get.snackbar(
          'Succès',
          accepter ? 'Demande acceptée' : 'Demande rejetée',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await _chargerDonnees();
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de traiter la demande',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  ValidationResult _validateDonnees({
    required String nom,
    required String prenom,
    required String filiereActuelle,
    required String choixNouvelleFiliere,
    required String motivation,
    required String level,
    required String facultyName,
    File? pieceJustificative,
  }) {
    final errors = <String>[];

    if (nom.trim().isEmpty) errors.add('Le nom est obligatoire');
    if (prenom.trim().isEmpty) errors.add('Le prénom est obligatoire');
    if (filiereActuelle.trim().isEmpty) errors.add('La filière actuelle est requise');
    if (choixNouvelleFiliere.trim().isEmpty) errors.add('La nouvelle filière est requise');
    if (motivation.trim().length < 10) errors.add('La motivation doit contenir au moins 10 caractères');
    if (filiereActuelle.trim() == choixNouvelleFiliere.trim()) errors.add('La nouvelle filière doit être différente de la filière actuelle');
    if (level.trim().isEmpty) errors.add('Le niveau est requis');
    if (facultyName.trim().isEmpty) errors.add('La faculté est requise');
    
    // Validation du fichier si présent
    if (pieceJustificative != null) {
      final fileSize = pieceJustificative.lengthSync();
      if (fileSize > 5 * 1024 * 1024) { // 5MB max
        errors.add('Le fichier ne doit pas dépasser 5MB');
      }
      final extension = pieceJustificative.path.split('.').last.toLowerCase();
      if (!['pdf', 'doc', 'docx'].contains(extension)) {
        errors.add('Le fichier doit être au format PDF ou Word');
      }
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  void _showSuccessNotification(String message) {
    Get.snackbar(
      'Succès',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  void _showErrorNotification(String message) {
    Get.snackbar(
      'Erreur',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }

  void reinitialiserEtats() {
    demandeCourante.value = null;
    errorMessage.value = '';
    mesDemandesReorientation.clear();
    demandesEnAttente.clear();
  }
}

class ValidationResult {
  final bool isValid;
  final List<String> errors;

  ValidationResult({required this.isValid, this.errors = const []});
}
