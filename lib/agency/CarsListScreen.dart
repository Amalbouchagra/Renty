import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CarListScreen extends StatelessWidget {
  // Fonction pour supprimer une voiture de Firestore
  Future<void> _deleteCar(String carId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('cars').doc(carId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Car deleted successfully!'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete car: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  // Fonction pour mettre à jour une voiture dans Firestore
  Future<void> _updateCar(String carId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('cars').doc(carId).update({
        'pricePerDay': 25.0, // Exemple de mise à jour du prix de location
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Car updated successfully!'),
        backgroundColor: Colors.blue,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update car: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car List'),
        backgroundColor: Color.fromARGB(255, 41, 114, 255),
        titleTextStyle: TextStyle(
          color: Colors.white, // Couleur du texte (ici blanc)
          fontSize: 22, // Taille du texte
          fontWeight: FontWeight.bold, // Poids du texte
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cars').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final carData = snapshot.data!.docs;

          return ListView.builder(
            itemCount: carData.length,
            itemBuilder: (ctx, index) {
              final car = carData[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                elevation: 5,
                child: ListTile(
                  leading: Image.network(car['image']),
                  title: Text(
                    car['name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Model: ${car['model']}'),
                      Text('Price per day: \$${car['pricePerDay']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bouton de mise à jour
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Appel de la fonction de mise à jour avec context
                          _updateCar(car.id, context);
                        },
                      ),
                      // Bouton de suppression
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Appel de la fonction de suppression avec context
                          _deleteCar(car.id, context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
