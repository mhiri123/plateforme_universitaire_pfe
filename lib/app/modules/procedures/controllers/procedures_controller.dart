import 'package:flutter/material.dart';

class ProceduresController with ChangeNotifier {
  int _currentStep = 0;

  // Liste des titres des étapes
  List<String> steps = [
    "Inscription sur la plateforme",
    "Sélectionner la traiterdemande à effectuer",
    "Fournir les documents nécessaires",
    "Soumettre la traiterdemande",
    "Suivi de la traiterdemande",
    "Résultat de la traiterdemande",
    "Finalisation et confirmation"
  ];

  // Détails pour chaque étape
  List<String> stepsDetails = [
    "Étape 1 : L'utilisateur doit créer un compte en fournissant son nom, son adresse e-mail et un mot de passe sécurisé. Si un compte existe déjà, il peut se connecter directement.",
    "Étape 2 : L'utilisateur doit sélectionner le type de traiterdemande à effectuer, soit une réorientation ou un transfert selon son parcours.",
    "Étape 3 : L'utilisateur doit télécharger les documents nécessaires comme les relevés de notes, lettres de motivation, etc.",
    "Étape 4 : Une fois les documents téléchargés et vérifiés, l'utilisateur soumet sa traiterdemande pour traitement.",
    "Étape 5 : L'utilisateur peut suivre l'état de sa traiterdemande dans son tableau de bord personnel, avec des notifications à chaque étape.",
    "Étape 6 : Une fois la traiterdemande traitée, l'utilisateur reçoit un résultat et des instructions supplémentaires si la traiterdemande est acceptée.",
    "Étape 7 : L'utilisateur finalise les démarches administratives et reçoit une confirmation de son inscription ou transfert."
  ];

  int get currentStep => _currentStep;

  // Avancer à l'étape suivante
  void nextStep() {
    if (_currentStep < steps.length - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  // Revenir à l'étape précédente
  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }
}

