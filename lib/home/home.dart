import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renty/auth/login.dart';
import 'package:renty/home/car_detail_screen.dart';

const Color primaryColor = Color.fromARGB(255, 41, 114, 255);
const Color whiteColor = Colors.white;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 0;
  String _selectedCategory = '';
  String _searchQuery = '';

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<List<Car>> _fetchCars() async {
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

    return snapshot.docs.map((doc) {
      return Car(
        name: doc['name'],
        model: doc['model'],
        pricePerDay: double.parse(doc['pricePerDay'].toString()),
        image: doc['image'],
        carId: doc.id,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7), // Subtle background color
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBox(),
            SizedBox(height: 20),
            _buildCategoryButtons(),
            SizedBox(height: 20),
            Text(
              "Available Cars",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
            SizedBox(height: 10),
            FutureBuilder<List<Car>>(
              future: _fetchCars(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No cars available.'));
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
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Start',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value.trim();
          });
        },
        decoration: InputDecoration(
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
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedCategory == category
                            ? primaryColor
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
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
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: cars.length,
      itemBuilder: (context, index) {
        return _buildCarCard(cars[index]);
      },
    );
  }

  Widget _buildCarCard(Car car) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarDetailScreen(car: car),
            ),
          );
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                car.image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    car.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(car.model, style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 6),
                  Text(
                    'AED ${car.pricePerDay.toStringAsFixed(2)} / day',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
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
  final String name;
  final double pricePerDay;
  final String image;
  final String carId;
  final String model;

  Car({
    required this.name,
    required this.pricePerDay,
    required this.image,
    required this.carId,
    required this.model,
  });
}
