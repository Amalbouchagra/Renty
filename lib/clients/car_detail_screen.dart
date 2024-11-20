import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:renty/clients/home.dart';

class CarDetailScreen extends StatelessWidget {
  final String carName;
  final String carPrice;

  // Constructor to accept carId, name, and price
  CarDetailScreen({
    required this.carName,
    required this.carPrice, required Car car,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Details'),
        backgroundColor: Color.fromARGB(255, 41, 114, 255),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('cars').doc(carName).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Car not found'));
          }

          var car = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Displaying car details
                Text(
                  'Car Name: ${car['name']}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Model: ${car['model']}'),
                Text('Registration Number: ${car['registrationNumber']}'),
                Text('Year: ${car['year']}'),
                Text('Mileage: ${car['mileage']} km'),
                Text('Fuel Type: ${car['fuelType']}'),
                Text('Transmission: ${car['transmission']}'),
                Text('Engine Capacity: ${car['engineCapacity']} CC'),
                Text('Price per Day: \$${car['pricePerDay']}'),
                Text('Location: ${car['location']}'),
                SizedBox(height: 20),
                Text('Conditions: ${car['conditions']}'),
                Text('Options: ${car['options']}'),
                SizedBox(height: 20),
                // Displaying car image if available
                car['image'].isNotEmpty
                    ? Image.network(car['image'])
                    : SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }
}
