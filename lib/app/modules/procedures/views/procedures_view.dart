import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../aboutus/views/aboutus_view.dart';
import '../../home/views/home_screen.dart';
import '../../login/views/login_view.dart';
import '../../news/views/news_view.dart';
import '../controllers/procedures_controller.dart';

class ProceduresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProceduresController(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Text("REO", style: TextStyle(color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold)),
              Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text("HOME", style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsScreen()),
                  );
                },
                child: Text("NEWS", style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutUsScreen()),
                  );
                },
                child: Text("ABOUT US", style: TextStyle(color: Colors.black)),
              ),
              TextButton(onPressed: () {}, child: Text("SERVICES", style: TextStyle(color: Colors.black))),
              TextButton(onPressed: () {}, child: Text("CONTACT", style: TextStyle(color: Colors.black))),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text("ENQUIRE TODAY"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text("LOGIN"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ),
        body: Consumer<ProceduresController>(
          builder: (context, controller, child) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/procedures.jpeg",
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.4),
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Étape ${controller.currentStep + 1}: ${controller.steps[controller.currentStep]}",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red[800]),
                          ),
                          SizedBox(height: 30),
                          Text(
                            "Détails: \n\n${controller.stepsDetails[controller.currentStep]}",
                            style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                          ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: controller.currentStep > 0 ? controller.previousStep : null,
                                icon: Icon(Icons.arrow_back, color: Colors.white),
                                label: Text("Précédent"),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                              ),
                              ElevatedButton.icon(
                                onPressed: controller.currentStep < controller.steps.length - 1 ? controller.nextStep : null,
                                icon: Icon(Icons.arrow_forward, color: Colors.white),
                                label: Text("Suivant"),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
