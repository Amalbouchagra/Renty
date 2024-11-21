import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:renty/auth/login.dart'; // Assurez-vous que le chemin vers Login est correct

class LogoutScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fonction pour gérer la déconnexion
  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut(); // Déconnexion avec Firebase
      // Redirection vers l'écran de connexion
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false,
      );
    } catch (e) {
      // Affichage d'une erreur en cas de problème
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la déconnexion : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Déconnexion'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: Icon(Icons.logout, color: Colors.white),
          label: Text(
            'Se déconnecter',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () =>
              _logout(context), // Appel de la fonction de déconnexion
        ),
      ),
    );
  }
}
