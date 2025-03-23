import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Importation des contrôleurs et vues
import '../../chat/controllers/chat_controller.dart';
import '../../demande/controllers/demande_controller.dart';
import '../../forgotpassword/views/forgotpassword_view.dart';
import '../../home/controllers/notification_controller.dart';
import '../../home/views/home_screen.dart';
import '../../homeadmin/views/homeadmin_view.dart';
import '../../homestudent/views/homestudent_view.dart';
import '../../hometeacher/views/hometeacher_view.dart';
import '../../signup/views/signup_view.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image de fond normale (sans flou)
          Positioned.fill(
            child: Image.asset(
              "assets/images/login.jpeg", // Remplacez par votre image
              fit: BoxFit.cover,
            ),
          ),
          // Contenu principal
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              width: 400,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("LOGIN", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email, color: Colors.red),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock, color: Colors.red),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Navigation vers l'écran de réinitialisation du mot de passe
                          Get.to(() => ForgotPasswordScreen());
                        },
                        child: Text("Forgot Password?", style: TextStyle(color: Colors.red)),
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _handleLogin();
                        }
                      },
                      child: Text("LOGIN"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?", style: TextStyle(color: Colors.black54)),
                        TextButton(
                          onPressed: () {
                            // Navigation vers l'écran d'inscription
                            Get.to(() => SignUpScreen());
                          },
                          child: Text("Sign Up", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Bouton retour vers HomeScreen
                    TextButton(
                      onPressed: () {
                        Get.offAll(() => HomeScreen());
                      },
                      child: Text("Back to Home", style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogin() {
    String email = emailController.text;
    String password = passwordController.text;

    if (email == 'admin@example.com' && password == 'password123') {
      Get.offAll(() => AdminHomeScreen(
        demandeController: Get.put(DemandeController()),
        chatController: Get.put(ChatController()),
        notificationController: Get.put(NotificationController()),
      ));
    } else if (email == 'teacher@example.com' && password == 'password123') {
      Get.offAll(() => TeacherHomeScreen(
        demandeController: Get.put(DemandeController()),
        chatController: Get.put(ChatController()),
        notificationController: Get.put(NotificationController()),
      ));
    } else if (email == 'student@example.com' && password == 'password123') {
      Get.offAll(() => StudentHomeScreen(
        demandeReoController: Get.put(DemandeController()),
        demandeTransfertController: Get.put(DemandeController()),
        chatController: Get.put(ChatController()),
        notificationController: Get.put(NotificationController()),
      ));
    } else {
      Get.snackbar("Error", "Invalid credentials",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}

