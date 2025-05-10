import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_controller.dart';
import '../../../models/reference_models.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final SignUpController controller = Get.put(SignUpController());

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.red),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: Colors.white,
      errorStyle: const TextStyle(color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/login.jpeg",
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 400,
                    minHeight: MediaQuery.of(context).size.height - 40,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Obx(() {
                      if (controller.roles.isEmpty || controller.faculties.isEmpty || controller.levels.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Colors.red),
                              SizedBox(height: 20),
                              Text("Chargement des données...", style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        );
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Inscription",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          const SizedBox(height: 20),

                          // Champs texte
                          TextField(
                            controller: controller.firstNameController,
                            decoration: inputDecoration("Prénom", Icons.person),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 15),

                          TextField(
                            controller: controller.lastNameController,
                            decoration: inputDecoration("Nom", Icons.person_outline),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 15),

                          TextField(
                            controller: controller.emailController,
                            decoration: inputDecoration("Email", Icons.email),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 15),

                          TextField(
                            controller: controller.passwordController,
                            obscureText: true,
                            decoration: inputDecoration("Mot de passe", Icons.lock),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 15),

                          TextField(
                            controller: controller.confirmPasswordController,
                            obscureText: true,
                            decoration: inputDecoration("Confirmer le mot de passe", Icons.lock_outline),
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 20),

                          // Sélection du rôle
                          DropdownButtonFormField<RoleModel>(
                            decoration: inputDecoration("Sélectionner un rôle", Icons.person),
                            value: controller.selectedRole.value,
                            hint: const Text("Choisir un rôle"),
                            onChanged: (RoleModel? newValue) {
                              controller.onRoleSelected(newValue);
                            },
                            items: controller.roles.map((role) {
                              return DropdownMenuItem(
                                value: role,
                                child: Text(role.name ?? ''),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 15),

                          // Faculté
                          if (controller.selectedRole.value?.name != 'super_admin')
                            Obx(() => DropdownButtonFormField<FacultyModel>(
                              decoration: inputDecoration("Sélectionner une faculté", Icons.account_balance),
                              value: controller.selectedFaculty.value,
                              onChanged: (FacultyModel? value) {
                                controller.onFacultySelected(value);
                              },
                              items: controller.faculties.map((f) {
                                return DropdownMenuItem(
                                  value: f,
                                  child: Text(f.facultyName ?? ''),
                                );
                              }).toList(),
                            )),
                          if (controller.selectedRole.value?.name != 'super_admin') const SizedBox(height: 15),

                          // Filière
                          if (controller.selectedRole.value?.name != 'super_admin')
                            Obx(() => DropdownButtonFormField<FiliereModel>(
                              decoration: inputDecoration("Sélectionner une filière", Icons.book),
                              value: controller.selectedFiliere.value,
                              onChanged: controller.onFiliereSelected,
                              items: controller.filieres.map((filiere) {
                                return DropdownMenuItem(
                                  value: filiere,
                                  child: Text(filiere.filiereName ?? ''),
                                );
                              }).toList(),
                            )),
                          if (controller.selectedRole.value?.name != 'super_admin') const SizedBox(height: 15),

                          // Niveau (uniquement si étudiant)
                          if (controller.selectedRole.value?.name?.toLowerCase() == 'etudiant')
                            Obx(() => DropdownButtonFormField<LevelModel>(
                              decoration: inputDecoration("Niveau", Icons.school),
                              value: controller.selectedLevel.value,
                              onChanged: controller.onLevelSelected,
                              items: controller.levels.map((level) {
                                return DropdownMenuItem(
                                  value: level,
                                  child: Text(level.level ?? ''),
                                );
                              }).toList(),
                            )),
                          if (controller.selectedRole.value?.name?.toLowerCase() == 'etudiant') const SizedBox(height: 20),

                          // Bouton d'inscription
                          ElevatedButton(
                            onPressed: () => controller.signUp(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text("S'inscrire", style: TextStyle(fontSize: 16, color: Colors.white)),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}