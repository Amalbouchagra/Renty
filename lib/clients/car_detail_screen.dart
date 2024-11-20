import 'package:flutter/material.dart';
import 'package:renty/clients/home.dart';

class CarDetailScreen extends StatelessWidget {
  final Car car;

  CarDetailScreen({required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(car.name)),
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
                // Action à effectuer lors de la réservation
                // Par exemple, afficher une boîte de dialogue ou naviguer vers une page de confirmation
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Reservation Confirmation'),
                    content: Text('Are you sure you want to reserve this car?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Ferme la boîte de dialogue
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Action pour réserver la voiture
                          // Par exemple, naviguer vers la page de confirmation de réservation
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Car Reserved!')),
                          );
                        },
                        child: Text('Reserve'),
                      ),
                    ],
                  ),
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
