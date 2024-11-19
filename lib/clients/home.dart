import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renty/auth/login.dart';
import 'package:renty/auth/signup.dart';
import 'car_detail_screen.dart';

// Define colors centrally to improve maintainability
const Color primaryColor = Color.fromARGB(255, 41, 114, 255);
const Color secondaryColor = Colors.lightBlue;
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
        pricePerDay: doc['pricePerDay'],
        image: doc['image'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
            _buildSectionTitle("Available Cars"),
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: primaryColor,
      title: Text(
        "Renty",
        style: TextStyle(
            color: whiteColor, fontSize: 22, fontWeight: FontWeight.bold),
      ),
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
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
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
            colors: [primaryColor, secondaryColor],
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
    return Column(
      children: cars.map((car) {
        return _buildCarCard(car);
      }).toList(),
    );
  }

  Widget _buildCarCard(Car car) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 150,
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  car.image, // Using network image or asset path
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(car.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 8),
                    Text(
                      '${car.pricePerDay.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.blueAccent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), label: 'Profile'),
      ],
    );
  }
}

class Car {
  final String name;
  final double pricePerDay;
  final String image;

  Car({
    required this.name,
    required this.pricePerDay,
    required this.image,
  });
}
