import 'package:get/get.dart';
import '../../../models/demande_reorientation_model.dart';
import '../../../models/demande_transfert_enseignant_model.dart';
import '../../../models/demande_transfert_etudiant_model.dart';

class AdminHomeController extends GetxController {
  final RxList<DemandeReorientation> demandesReorientation = <DemandeReorientation>[].obs;
  final RxList<DemandeTransfertEtudiant> demandesTransfertEtudiant = <DemandeTransfertEtudiant>[].obs;
  final RxList<DemandeTransfertEnseignant> demandesTransfertEnseignant = <DemandeTransfertEnseignant>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> recupererDemandesReorientation() async {
    try {
      isLoading.value = true;

      demandesReorientation.value = [
        DemandeReorientation(
          nom: 'Dupont',
          prenom: 'Jean',
          filiereActuelleNom: 'Science',  // Mise à jour du nom de la filière actuelle
          nouvelleFiliereNom: 'Informatique', // Mise à jour du nom de la nouvelle filière
          motivation: 'Changement de parcours',
          statut: StatutDemande.enAttente,
          commentaireAdmin: '',
          level: 'Niveau 1',
          facultyName: 'Faculté des Sciences',
        ),
      ];
    } catch (e) {
      errorMessage.value = 'Erreur lors de la récupération des demandes de réorientation';
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> recupererDemandesTransfertEtudiant() async {
    try {
      isLoading.value = true;
      demandesTransfertEtudiant.value = [
        // Ajouter des données de transfert étudiant si nécessaire
      ];
    } catch (e) {
      errorMessage.value = 'Erreur lors de la récupération des demandes de transfert étudiant';
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> recupererDemandesTransfertEnseignant() async {
    try {
      isLoading.value = true;
      demandesTransfertEnseignant.value = [
        DemandeTransfertEnseignant(
          nom: 'Leroy',
          prenom: 'Pierre',
          email: 'pierre.leroy@example.com',
          universiteActuelle: 'Université A',
          faculteActuelle: 'Faculté des Sciences',
          universiteDemandee: 'Université B',
          motivation: 'Opportunité de recherche',
          statut: DemandeTransfertEnseignant.STATUT_EN_ATTENTE,
        ),
      ];
    } catch (e) {
      errorMessage.value = 'Erreur lors de la récupération des demandes de transfert enseignant';
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> traiterDemandeReorientation(DemandeReorientation demande, bool estAcceptee) async {
    try {
      isLoading.value = true;

      final nouveauStatut = estAcceptee
          ? StatutDemande.acceptee
          : StatutDemande.rejetee;

      final index = demandesReorientation.indexOf(demande);
      if (index != -1) {
        demandesReorientation[index] = demande.copyWith(statut: nouveauStatut);
      }

      print(estAcceptee
          ? 'Demande de réorientation acceptée'
          : 'Demande de réorientation refusée');
    } catch (e) {
      errorMessage.value = 'Erreur lors du traitement de la demande de réorientation';
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> traiterDemandeTransfertEtudiant(DemandeTransfertEtudiant demande, bool estAcceptee) async {
    try {
      isLoading.value = true;

      print(estAcceptee
          ? 'Demande de transfert étudiant acceptée'
          : 'Demande de transfert étudiant refusée');
    } catch (e) {
      errorMessage.value = 'Erreur lors du traitement de la demande de transfert étudiant';
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> traiterDemandeTransfertEnseignant(DemandeTransfertEnseignant demande, bool estAcceptee) async {
    try {
      isLoading.value = true;

      demande.statut = estAcceptee
          ? DemandeTransfertEnseignant.STATUT_ACCEPTE
          : DemandeTransfertEnseignant.STATUT_REFUSE;

      demandesTransfertEnseignant.remove(demande);

      print(estAcceptee
          ? 'Demande de transfert enseignant acceptée'
          : 'Demande de transfert enseignant refusée');
    } catch (e) {
      errorMessage.value = 'Erreur lors du traitement de la demande de transfert enseignant';
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> ajouterCommentaire(dynamic demande, String commentaire) async {
    try {
      isLoading.value = true;

      if (demande is DemandeReorientation) {
        final index = demandesReorientation.indexOf(demande);
        if (index != -1) {
          demandesReorientation[index] =
              demande.copyWith(commentaireAdmin: commentaire);
        }
      } else if (demande is DemandeTransfertEnseignant) {
        final index = demandesTransfertEnseignant.indexOf(demande);
        if (index != -1) {
          demande.commentaireAdministration = commentaire;
        }
      }

      print('Commentaire ajouté avec succès');
    } catch (e) {
      errorMessage.value = 'Erreur lors de l\'ajout du commentaire';
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
