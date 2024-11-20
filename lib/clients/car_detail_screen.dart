import 'package:flutter/material.dart';
import 'package:renty/clients/home.dart'; // Importation de la classe Car
import 'package:renty/clients/reservation_screen.dart'; // Importation de la page de réservation

class CarDetailScreen extends StatelessWidget {
  final Car car; // Car est une classe que vous devez définir dans home.dart

  CarDetailScreen({required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(car.name)), // Affichage du nom de la voiture dans l'AppBar
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affichage de l'image de la voiture
            Image.asset(
              car.image,
              width: 800, // Largeur fixe
              height: 300, // Hauteur fixe
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            // Nom de la voiture
            Text(
              car.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Prix par jour
            Text(
              'AED ${car.pricePerDay.toStringAsFixed(2)} per day',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            // Modèle de la voiture
            Text(
              car.model,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Bouton de réservation
            ElevatedButton(
              onPressed: () {
                // Naviguer vers ReservationScreen lorsque l'utilisateur clique sur le bouton
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReservationScreen()),
                );
              },
              child: Text('Reserve Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Couleur du bouton
                padding: EdgeInsets.symmetric(
                    vertical: 12, horizontal: 20), // Padding du bouton
                textStyle:
                    TextStyle(fontSize: 16), // Taille du texte dans le bouton
              ),
            ),
          ],
        ),
      ),
    );
  }
}
