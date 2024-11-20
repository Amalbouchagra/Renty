import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReservationScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  // Référence à la collection "reservations" dans Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fonction pour ajouter la réservation à Firestore
  Future<void> _submitReservation(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String carModel = _carModelController.text;
      String startDate = _startDateController.text;
      String duration = _durationController.text;

      try {
        // Ajout de la réservation à Firestore
        await _firestore.collection('reservations').add({
          'carModel': carModel,
          'startDate': startDate,
          'duration': int.parse(duration),
          'reservationDate': Timestamp.now(), // Date de la réservation
        });

        // Affichage de la boîte de confirmation
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Reservation Confirmed'),
            content: Text(
              'You have reserved a $carModel starting from $startDate for $duration day(s).',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );

        // Effacement des champs du formulaire
        _carModelController.clear();
        _startDateController.clear();
        _durationController.clear();
      } catch (e) {
        // Affichage d'un message d'erreur en cas de problème avec Firestore
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while saving the reservation: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Champ pour le modèle de voiture
              TextFormField(
                controller: _carModelController,
                decoration: InputDecoration(
                  labelText: 'Car Model',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the car model';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Champ pour la date de début
              TextFormField(
                controller: _startDateController,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    _startDateController.text =
                        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a start date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Champ pour la durée de la réservation
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: 'Duration (in days)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the duration';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid number of days';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Bouton pour soumettre la réservation
              ElevatedButton(
                onPressed: () =>
                    _submitReservation(context), // Passe context ici
                child: Text('Reserve Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
