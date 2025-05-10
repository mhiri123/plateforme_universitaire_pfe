import 'package:flutter/material.dart';

class UnknownRoleScreen extends StatelessWidget {
  const UnknownRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rôle Inconnu'),
        backgroundColor: Colors.redAccent,
      ),
      body: const Center(
        child: Text(
          'Rôle non reconnu. Veuillez contacter l\'administrateur.',
          style: TextStyle(fontSize: 18, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
