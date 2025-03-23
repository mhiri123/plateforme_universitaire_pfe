import 'package:flutter/material.dart';

class SignUpController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String selectedRole = 'Student'; // Rôle par défaut

  // Fonction pour gérer l'inscription
  String? validateFields() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Vérifier si tous les champs sont remplis
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      return "All fields are required.";
    }

    // Vérifier le format de l'email
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return "Enter a valid email address.";
    }

    // Vérifier la longueur du mot de passe
    if (password.length < 6) {
      return "Password must be at least 6 characters.";
    }

    // Vérifier si les mots de passe correspondent
    if (password != confirmPassword) {
      return "Passwords do not match.";
    }

    return null; // Aucune erreur
  }

  // Fonction pour enregistrer un utilisateur (Simulation)
  void signUp(BuildContext context) {
    String? errorMessage = validateFields();
    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }

    // Rediriger l'utilisateur vers la page d'accueil en fonction du rôle
    if (selectedRole == "Student") {
      Navigator.pushReplacementNamed(context, "/studentHome");
    } else if (selectedRole == "Teacher") {
      Navigator.pushReplacementNamed(context, "/teacherHome");
    } else if (selectedRole == "Admin") {
      Navigator.pushReplacementNamed(context, "/adminHome");
    }
  }
}
