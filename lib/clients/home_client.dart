import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:renty/clients/profile_client.dart';
import 'car_detail_client.dart';

const Color primaryColor = Color.fromARGB(255, 41, 114, 255);
const Color whiteColor = Colors.white;

class HomeClient extends StatefulWidget {
  final String userId;

  const HomeClient({Key? key, required this.userId}) : super(key: key);

  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 0;
  String _selectedCategory = '';
  String _searchQuery = '';
  List<String> _favoriteCars = [];

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileClient()),
      );
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  Future<List<Car>> _fetchCars() async {
    try {
      Query query = _firestore.collection('cars');

      if (_selectedCategory.isNotEmpty) {
        query = query.where('category', isEqualTo: _selectedCategory);
      }

      if (_searchQuery.isNotEmpty) {
        query = query
            .where('name', isGreaterThanOrEqualTo: _searchQuery)
            .where('name', isLessThanOrEqualTo: '$_searchQuery\uf8ff');
      }

      QuerySnapshot snapshot = await query.get();
      return snapshot.docs.map((doc) => Car.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error fetching cars: $e");
      return [];
    }
  }

  Future<void> _fetchFavorites() async {
    try {
      if (widget.userId.isEmpty) {
        print("Error: userId is empty.");
        return;
      }

      // Récupérer les voitures favorites de la sous-collection 'favorites' de l'utilisateur
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('favorites')
          .get();

      setState(() {
        _favoriteCars = snapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print("Error fetching favorites: $e");
    }
  }

  Future<void> _toggleFavorite(String carId) async {
    if (carId.isEmpty) {
      print("Car ID is empty. Cannot toggle favorite.");
      return; // Retourne immédiatement si carId est vide
    }

    if (widget.userId.isEmpty) {
      print("User ID is empty. Cannot toggle favorite.");
      return; // Retourne immédiatement si userId est vide
    }

    try {
      final isFavorite = _favoriteCars.contains(carId);

      setState(() {
        if (isFavorite) {
          _favoriteCars.remove(carId);
        } else {
          _favoriteCars.add(carId);
        }
      });

      // Ajouter ou supprimer la voiture de la sous-collection 'favorites'
      if (isFavorite) {
        await _firestore
            .collection('users')
            .doc(widget.userId)
            .collection('favorites')
            .doc(carId)
            .delete();
      } else {
        await _firestore
            .collection('users')
            .doc(widget.userId)
            .collection('favorites')
            .doc(carId)
            .set({}); // Document vide, représente le favori
      }
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.userId.isNotEmpty) {
      _fetchFavorites();
    } else {
      print("Error: userId is empty at initialization.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        // Ajout de SingleChildScrollView pour permettre le défilement
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBox(),
            const SizedBox(height: 20),
            _buildCategoryButtons(),
            const SizedBox(height: 20),
            const Text(
              "Available Cars",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<Car>>(
              future: _fetchCars(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No cars available.'));
                } else {
                  return _buildCarList(snapshot.data!);
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value.trim()),
        decoration: const InputDecoration(
          hintText: 'Search for a car',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: primaryColor),
        ),
      ),
    );
  }

  Widget _buildCategoryButtons() {
    final categories = [
      "Luxury",
      "Sport",
      "SUV",
      "Convertible",
      "Business",
      "Electric (EV)",
      "VAN",
      "Economy"
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories
            .map((category) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = category),
                    child: Chip(
                      backgroundColor: _selectedCategory == category
                          ? primaryColor
                          : Colors.grey.shade300,
                      label: Text(
                        category,
                        style: TextStyle(
                          color: _selectedCategory == category
                              ? whiteColor
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildCarList(List<Car> cars) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: cars.length,
      itemBuilder: (context, index) => _buildCarCard(cars[index]),
    );
  }

  Widget _buildCarCard(Car car) {
    final isFavorite = _favoriteCars.contains(car.carId);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarDetailClient(
                car: car,
                carId: car.carId, // Utilisez le bon identifiant
              ),
            ),
          );
        },
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    car.image,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: const Color.fromARGB(255, 255, 41, 41),
                    ),
                    onPressed: () => _toggleFavorite(car.carId),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    car.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(car.model, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 6),
                  Text(
                    'AED ${car.pricePerDay.toStringAsFixed(2)} / day',
                    style: const TextStyle(color: primaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Car {
  final String carId;
  final String name;
  final String model;
  final String image;
  final double pricePerDay;

  Car({
    required this.carId,
    required this.name,
    required this.model,
    required this.image,
    required this.pricePerDay,
  });

  factory Car.fromFirestore(DocumentSnapshot doc) {
    return Car(
      carId: doc.id,
      name: doc['name'],
      model: doc['model'],
      image: doc['image'],
      pricePerDay: doc['pricePerDay'].toDouble(),
    );
  }
}
