import 'package:flutter/material.dart';
import 'package:renty/clients/home_client.dart';
import 'package:renty/clients/reservation_client.dart';

class CarDetailClient extends StatelessWidget {
  final Car car;
  final String carId;

  const CarDetailClient({Key? key, required this.car, required this.carId})
      : super(key: key);

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
                // Naviguer vers la page ReservationClient avec le paramètre car
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationClient(car: car),
                  ),
                );
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
}
