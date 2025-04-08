import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/request_management_controller.dart';

class RequestManagementScreen extends StatelessWidget {
  final RequestManagementController requestController = Get.put(RequestManagementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestion des Demandes")),
      body: Obx(() {
        return ListView.builder(
          itemCount: requestController.requests.length,
          itemBuilder: (context, index) {
            final request = requestController.requests[index];
            return ListTile(
              title: Text("Type: ${request.type}"),
              subtitle: Text("Statut: ${request.status}"),
              trailing: IconButton(
                icon: Icon(Icons.check_circle, color: Colors.green),
                onPressed: () {
                  requestController.approveRequest(request.id);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
