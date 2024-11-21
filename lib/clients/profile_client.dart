import 'package:flutter/material.dart';

import 'package:renty/auth/logout.dart'; // Page de déconnexion

class ClientDashboard extends StatelessWidget {
  final String username;

  ClientDashboard({required this.username});

  // Fonction pour déconnecter l'utilisateur
  void _logout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LogoutScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord du client'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () => _logout(context),
            tooltip: 'Déconnexion',
          ),
        ],
      ),
    );
  }
}
