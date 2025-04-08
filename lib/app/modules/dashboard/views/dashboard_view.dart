import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tableau de Bord")),
      body: Obx(() {
        return Column(
          children: [
            // Statistiques
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard("En attente", dashboardController.pendingRequests.value),
                _buildStatCard("Acceptées", dashboardController.acceptedRequests.value),
                _buildStatCard("Rejetées", dashboardController.rejectedRequests.value),
              ],
            ),
            SizedBox(height: 20),
            // Liste des activités récentes
            Expanded(
              child: ListView.builder(
                itemCount: dashboardController.activities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dashboardController.activities[index]),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatCard(String title, int count) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("$count", style: TextStyle(fontSize: 24, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
