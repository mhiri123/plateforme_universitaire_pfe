import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/demandereo_controller.dart';

class ReorientationRequestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ReorientationRequestsController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text("Reorientation Requests"),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: controller.loadRequests,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.requests.isEmpty) {
          return Center(child: Text("No reorientation requests found."));
        }

        return ListView.builder(
          itemCount: controller.requests.length,
          itemBuilder: (context, index) {
            final request = controller.requests[index];
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text("Request from: ${request.studentName}"),
                subtitle: Text("Current: ${request.currentField} → New: ${request.desiredField}"),
                trailing: Chip(
                  label: Text(request.status),
                  backgroundColor: request.status == "Pending" ? Colors.orange : Colors.green,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
