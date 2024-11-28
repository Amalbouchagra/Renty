import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renty/clients/home_client.dart';

class FavoritesPage extends StatefulWidget {
  final String userId;

  const FavoritesPage({Key? key, required this.userId}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Car> _favoriteCars = [];

  @override
  void initState() {
    super.initState();
    _fetchFavoriteCars();
  }

  Future<void> _fetchFavoriteCars() async {
    try {
      // Récupérer les documents dans la sous-collection 'favorites'
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('favorites')
          .get();

      List<String> favoriteCarIds = snapshot.docs
          .map((doc) => doc.id) // L'ID du document est l'ID de la voiture
          .toList();

      if (favoriteCarIds.isNotEmpty) {
        // Charger les détails des voitures favorites
        QuerySnapshot carSnapshot = await _firestore
            .collection('cars')
            .where(FieldPath.documentId, whereIn: favoriteCarIds)
            .get();

        setState(() {
          _favoriteCars =
              carSnapshot.docs.map((doc) => Car.fromFirestore(doc)).toList();
        });
      } else {
        setState(() {
          _favoriteCars = [];
        });
      }
    } catch (e) {
      print("Error fetching favorite cars: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: ListView.builder(
        itemCount: _favoriteCars.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(_favoriteCars[index].image),
            title: Text(_favoriteCars[index].name),
            subtitle: Text(_favoriteCars[index].model),
          );
        },
      ),
    );
  }
}
