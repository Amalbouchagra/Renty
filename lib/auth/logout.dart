import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logout"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              // Perform logout
              await FirebaseAuth.instance.signOut();

              // After successful logout, navigate to the login screen
              Navigator.pushReplacementNamed(context, 'Home');
            } catch (e) {
              // If an error occurs during sign out
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error signing out: $e")),
              );
            }
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}
