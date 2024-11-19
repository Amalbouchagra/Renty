import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class AddCarScreen extends StatefulWidget {
  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final TextEditingController _carIdController = TextEditingController();
  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _carYearController = TextEditingController();
  final TextEditingController _carMileageController = TextEditingController();
  final TextEditingController _fuelTypeController = TextEditingController();
  final TextEditingController _transmissionController = TextEditingController();
  final TextEditingController _engineCapacityController =
      TextEditingController();
  final TextEditingController _carPriceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _conditionsController = TextEditingController();
  final TextEditingController _optionsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Fonction pour ajouter une voiture dans Firestore
  Future<void> _addCarToFirebase() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Affiche un indicateur de chargement pendant l'opération Firestore
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator()),
        );

        // Ajout des données à Firestore
        await FirebaseFirestore.instance.collection('cars').add({
          'id': _carNameController.text.trim(),
          'name': _carNameController.text.trim(),
          'model': _carModelController.text.trim(),
          'registrationNumber': _registrationNumberController.text.trim(),
          'year': int.tryParse(_carYearController.text.trim()) ?? 0,
          'mileage': int.tryParse(_carMileageController.text.trim()) ?? 0,
          'fuelType': _fuelTypeController.text.trim(),
          'transmission': _transmissionController.text.trim(),
          'engineCapacity':
              int.tryParse(_engineCapacityController.text.trim()) ?? 0,
          'pricePerDay':
              double.tryParse(_carPriceController.text.trim()) ?? 0.0,
          'location': _locationController.text.trim(),
          'image': _imageController.text.trim(),
          'addedAt': Timestamp.now(),
          'conditions': _conditionsController.text.trim(),
          'options': _optionsController.text.trim(),
        });

        Navigator.of(context).pop(); // Ferme l'indicateur de chargement

        // Affiche un message de succès
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Car added successfully!'),
          backgroundColor: Colors.green,
        ));

        // Réinitialise les champs du formulaire
        _carIdController.clear();
        _carNameController.clear();
        _carModelController.clear();
        _registrationNumberController.clear();
        _carYearController.clear();
        _carMileageController.clear();
        _fuelTypeController.clear();
        _transmissionController.clear();
        _engineCapacityController.clear();
        _carPriceController.clear();
        _locationController.clear();
        _imageController.clear();
        _conditionsController.clear();
        _optionsController.clear();
      } catch (e) {
        Navigator.of(context)
            .pop(); // Ferme l'indicateur de chargement en cas d'erreur

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to add car: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Car'),
        backgroundColor: Color.fromARGB(255, 41, 114, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                TextFormField(
                  controller: _carIdController,
                  decoration: InputDecoration(labelText: 'Car Id'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter car Id';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _carNameController,
                  decoration: InputDecoration(labelText: 'Car Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter car name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _carModelController,
                  decoration: InputDecoration(labelText: 'Car Model'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter car model';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _registrationNumberController,
                  decoration: InputDecoration(labelText: 'Registration Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter car registration number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _carYearController,
                  decoration: InputDecoration(labelText: 'Year of Manufacture'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the year';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid year';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _carMileageController,
                  decoration: InputDecoration(labelText: 'Mileage (in km)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the mileage';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid mileage';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _fuelTypeController,
                  decoration: InputDecoration(labelText: 'Fuel Type'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter fuel type';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _transmissionController,
                  decoration: InputDecoration(labelText: 'Transmission'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter transmission type';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _engineCapacityController,
                  decoration:
                      InputDecoration(labelText: 'Engine Capacity (in CC)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter engine capacity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid engine capacity';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _carPriceController,
                  decoration: InputDecoration(labelText: 'Price Per Day'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter car price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _imageController,
                  decoration: InputDecoration(labelText: 'Image URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter image URL';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _conditionsController,
                  decoration: InputDecoration(labelText: 'Conditions'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _optionsController,
                  decoration: InputDecoration(
                      labelText: 'Options (e.g., GPS, Seat Cover)'),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _addCarToFirebase,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 41, 114, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    'Add Car',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
