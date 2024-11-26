import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:renty/clients/car_detail_client.dart';
import 'package:renty/clients/home_client.dart'; // Importez la classe Car

class FavoritesPage extends StatefulWidget {
  final String userId;

  const FavoritesPage({Key? key, required this.userId}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> _favoriteCarIds = []; // Liste des IDs des voitures favorites

  Future<List<Car>> _fetchFavoriteCars() async {
    List<Car> favoriteCars = [];
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(widget.userId).get();

      if (userSnapshot.exists) {
        final data = userSnapshot.data() as Map<String, dynamic>?;
        List<String> favoriteIds = List<String>.from(data?['favorites'] ?? []);

        for (var carId in favoriteIds) {
          DocumentSnapshot carSnapshot =
              await _firestore.collection('cars').doc(carId).get();
          if (carSnapshot.exists) {
            final car = Car.fromFirestore(carSnapshot);
            favoriteCars.add(car);
          }
        }
      }
    } catch (e) {
      print("Error fetching favorite cars: $e");
    }
    return favoriteCars;
  }

  @override
  void initState() {
    super.initState();
    _fetchFavoriteCars(); // Récupérer les voitures favorites au démarrage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: const Color.fromARGB(255, 41, 114, 255),
      ),
      body: FutureBuilder<List<Car>>(
        future: _fetchFavoriteCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite cars.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Car car = snapshot.data![index];
                return ListTile(
                  title: Text(car.name),
                  subtitle: Text(car.model),
                  leading: Image.network(car.image,
                      width: 50, height: 50, fit: BoxFit.cover),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarDetailClient(
                          car: car,
                          carId: car.carId,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
