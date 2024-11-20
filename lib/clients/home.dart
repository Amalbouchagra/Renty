import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renty/auth/login.dart';
import 'package:renty/auth/signup.dart';
import 'package:renty/clients/car_detail_screen.dart';



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
  return GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.2,
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
            builder: (context) => CarDetailScreen(car: car, carName: '', carPrice: '',
             
             
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.asset(
                  car.image,
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Black Friday",
                    style: TextStyle(color: whiteColor, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  car.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'AED ${car.pricePerDay.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'AED ${(car.pricePerDay * 1.2).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: greyColor,
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '-20%',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}




  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home , color: Color.fromARGB(255, 20, 118, 247),), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.explore ,color: Color.fromARGB(255, 20, 118, 247)), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.search ,color: Color.fromARGB(255, 20, 118, 247)), label: 'Search'),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle ,color: Color.fromARGB(255, 20, 118, 247)), label: 'Profile'),
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
