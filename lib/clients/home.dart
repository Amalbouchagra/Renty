import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renty/auth/login.dart';
import 'package:renty/auth/signup.dart';
import 'package:renty/clients/car_detail_screen.dart';

const Color primaryColor = Color.fromARGB(255, 41, 114, 255);
const Color whiteColor = Colors.white;
const Color greyColor = Colors.grey;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all cars from Firebase without any filter
  Future<List<Car>> _fetchCars() async {
    QuerySnapshot snapshot = await _firestore.collection('cars').get();

    return snapshot.docs.map((doc) {
      return Car(
        name: doc['name'],
        model: doc['model'],
        pricePerDay: double.parse(doc['pricePerDay'].toString()),
        image: doc['image'],
        carId: doc.id, // Use car ID for fetching details later
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBox(),
            SizedBox(height: 20),
            _buildCategoryButtons(),
            SizedBox(height: 20),
            _buildSectionTitle(""),
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
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: whiteColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Text(
              'Renty Menu',
              style: TextStyle(color: whiteColor, fontSize: 24),
            ),
          ),
          _buildDrawerItem(
              icon: Icons.login,
              text: 'Login',
              onTap: () {
                _navigateTo(context, Login());
              }),
          _buildDrawerItem(
              icon: Icons.person_add,
              text: 'User Signup',
              onTap: () {
                _navigateTo(context, UserSignup());
              }),
          _buildDrawerItem(
              icon: Icons.business_center,
              text: 'Agency Signup',
              onTap: () {
                _navigateTo(context, AgencySignup());
              }),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Widget _buildDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }

  Widget _buildSearchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(31, 12, 12, 12),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for a car',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: primaryColor),
        ),
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCategoryButton("Luxury"),
        _buildCategoryButton("Sport"),
        _buildCategoryButton("SUV"),
        _buildCategoryButton("Convertible"),
        _buildCategoryButton("Business"),
        _buildCategoryButton("Electric (EV)"),
        _buildCategoryButton("VAN"),
        _buildCategoryButton("Economy"),
      ],
    );
  }

  Widget _buildCategoryButton(String category) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [primaryColor, primaryColor.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(category,
              style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildCarList(List<Car> cars) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Deux cartes par ligne
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85, // Rapport largeur/hauteur compact
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
      elevation: 3,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                car.image,
                width: double.infinity,
                height: 150, // Hauteur réduite pour l'image
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    car.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    car.model,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'AED ${car.pricePerDay.toStringAsFixed(2)} / day',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
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
  Car(
      {required this.name,
      required this.pricePerDay,
      required this.image,
      required this.carId,
      required this.model});
}
