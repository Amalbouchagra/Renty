import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:renty/clients/home_client.dart'; // Assurez-vous que cette importation est correcte

class ReservationClient extends StatefulWidget {
  final Car car;

  ReservationClient({required this.car});

  @override
  _ReservationClientState createState() => _ReservationClientState();
}

class _ReservationClientState extends State<ReservationClient> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reserve',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Car: ${widget.car.name} (${widget.car.model})'),
                Text(
                    'Price per day: AED ${widget.car.pricePerDay.toStringAsFixed(2)}'),
                SizedBox(height: 10),
                Text('Enter your phone number:'),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: '+216 | Phone number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number is required';
                    }
                    if (!RegExp(r'^\d{8}$').hasMatch(value.trim())) {
                      return 'Enter a valid 8-digit phone number';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Start date is required';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Duration is required';
                    }
                    final duration = int.tryParse(value);
                    if (duration == null || duration <= 0) {
                      return 'Enter a valid number of days';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitReservation();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please correct the errors')),
                      );
                    }
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
        ),
      ),
    );
  }

  void _submitReservation() {
    final phone = phoneController.text;
    final startDate = startDateController.text;
    final durationStr = durationController.text;
    final duration = int.tryParse(durationStr);
    final currentUserId = FirebaseAuth
        .instance.currentUser?.uid; // Obtient l'ID utilisateur actuel

    if (phone.isEmpty || startDate.isEmpty || duration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly!')),
      );
      return;
    }

    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User is not logged in')),
      );
      return;
    }

    // Ajouter la réservation à Firestore
    FirebaseFirestore.instance.collection('reservations').add({
      'carName': widget.car.name,
      'carModel': widget.car.model,
      'pricePerDay': widget.car.pricePerDay,
      'phone': phone,
      'startDate': startDate,
      'duration': duration,
      'totalPrice': widget.car.pricePerDay * duration,
      'createdAt': DateTime.now(),
      'clientId':
          currentUserId, // Ajout de l'ID de l'utilisateur (userId) au champ clientId
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
