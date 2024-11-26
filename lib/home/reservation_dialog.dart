import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renty/home/home.dart';

class ReservationDialog extends StatelessWidget {
  final Car car;

  ReservationDialog({required this.car});

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController startDateController = TextEditingController();
    final TextEditingController durationController = TextEditingController();

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
            Text('Price per day: AED ${car.pricePerDay.toStringAsFixed(2)}'),
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
            Text('Select start date:'),
            TextFormField(
              controller: startDateController,
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
                  startDateController.text =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                }
              },
              readOnly: true,
            ),
            SizedBox(height: 10),
            Text('Enter duration in days:'),
            TextFormField(
              controller: durationController,
              decoration: InputDecoration(
                labelText: 'Duration (Days)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _submitReservation(
                  context,
                  car,
                  phoneController.text.trim(),
                  startDateController.text.trim(),
                  durationController.text.trim(),
                );
              },
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 41, 114, 255),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitReservation(
    BuildContext context,
    Car car,
    String phone,
    String startDate,
    String durationStr,
  ) {
    final duration = int.tryParse(durationStr);

    if (phone.isEmpty || startDate.isEmpty || duration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly!')),
      );
      return;
    }

    // Envoyer la réservation à Firestore
    FirebaseFirestore.instance.collection('reservations').add({
      'carName': car.name,
      'carModel': car.model,
      'pricePerDay': car.pricePerDay,
      'phone': phone,
      'startDate': startDate,
      'duration': duration,
      'totalPrice': car.pricePerDay * duration,
      'createdAt': DateTime.now(),
    }).then((_) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation submitted successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit reservation: $error')),
      );
    });
  }
}
