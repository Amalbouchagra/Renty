import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:renty/clients/home.dart';

class CarDetailScreen extends StatelessWidget {
  final Car car;

  CarDetailScreen({required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(car.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affichage de l'image de la voiture
            Image.asset(
              car.image,
              width: double.infinity,
              height: 300, // Hauteur réduite
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text(
              car.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'AED ${car.pricePerDay.toStringAsFixed(2)} per day',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            Text(
              car.model,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showReservationDialog(context, car);
              },
              child: Text('Reserve Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReservationDialog(BuildContext context, Car car) {
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController _startDateController = TextEditingController();
    final TextEditingController _durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reserve',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Car: ${car.name} (${car.model})'),
                Text(
                    'Price per day: AED ${car.pricePerDay.toStringAsFixed(2)}'),
                SizedBox(height: 10),
                Text('Enter your phone number:'),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: '+216 | Phone number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 10),
                // Date de début
                Text('Select start date:'),
                TextFormField(
                  controller: _startDateController,
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      _startDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                  readOnly: true,
                ),
                SizedBox(height: 10),
                // Durée de la réservation
                Text('Enter duration in days:'),
                TextFormField(
                  controller: _durationController,
                  decoration: InputDecoration(
                    labelText: 'Duration (Days)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String phone = phoneController.text.trim();
                    String startDate = _startDateController.text.trim();
                    int? duration =
                        int.tryParse(_durationController.text.trim());

                    if (phone.isNotEmpty &&
                        startDate.isNotEmpty &&
                        duration != null) {
                      _sendReservationToFirebase(
                          car, phone, startDate, duration);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Please fill all fields correctly!')),
                      );
                    }
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _sendReservationToFirebase(
      Car car, String phone, String startDate, int duration) async {
    try {
      await FirebaseFirestore.instance.collection('reservations').add({
        'carName': car.name,
        'carModel': car.model,
        'pricePerDay': car.pricePerDay,
        'phone': phone,
        'startDate': startDate,
        'duration': duration,
        'totalPrice': car.pricePerDay * duration,
        'date': DateTime.now(),
      });
      print('Reservation sent to Firebase!');
    } catch (e) {
      print('Failed to send reservation: $e');
    }
  }
}
