import 'package:flutter/material.dart';

import 'package:renty/auth/login.dart';
import 'package:renty/home/home.dart';
import 'reservation_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CarDetailScreen extends StatelessWidget {
  final Car car;

  CarDetailScreen({required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(car.name),
        backgroundColor: Color.fromARGB(255, 41, 114, 255),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affichage de l'image de la voiture
            Image.network(
              car.image,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text(
              car.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'AED ${car.pricePerDay.toStringAsFixed(2)} per day',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            SizedBox(height: 8),
            Text(
              'Model: ${car.model}',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _onReserveButtonPressed(context, car);
              },
              child: Text('Reserve Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 41, 114, 255),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onReserveButtonPressed(BuildContext context, Car car) {
    // Vérification si l'utilisateur est connecté
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else {
      // Ouvrir le dialogue de réservation
      showDialog(
        context: context,
        builder: (context) {
          return ReservationDialog(car: car);
        },
      );
    }
  }
}
