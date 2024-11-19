import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Page de Profil',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Utilisateur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Image de profil
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://play-lh.googleusercontent.com/Tp-jathoEc5EzukDRWl5hWQ8QbU1MWKUcJwlsF5uu9WiX01B42Bd3uoy85c8a6Hjag'), // Remplacez avec une URL ou une image locale
              ),
            ),
            SizedBox(height: 20),
            
            // Nom de l'utilisateur
            Text(
              'Nom de l\'Utilisateur',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Email : utilisateur@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            
            // Informations supplémentaires (exemple de biographie)
            Text(
              'Bio :',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Bonjour, je suis un développeur Flutter passionné par la création d\'applications mobiles modernes.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 20),
            
            // Bouton de modification du profil
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Action pour modifier le profil
                },
                child: Text('Modifier le Profil'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
