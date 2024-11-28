import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:renty/clients/ReservationsList.dart';
import 'package:renty/clients/favorites_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.grey[600]),
        ),
      ),
      home: ProfileClient(),
    );
  }
}

class ProfileClient extends StatefulWidget {
  @override
  _ProfileClientState createState() => _ProfileClientState();
}

class _ProfileClientState extends State<ProfileClient> {
  String userName = 'John Doe'; // Example name
  String userRole = 'Admin'; // Example role
  int selectedOptionIndex = -1;

  void onOptionTap(int index) {
    setState(() {
      selectedOptionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Profile Header
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              children: [
                // Profile Image
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    userName[0], // Display first letter of the name
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      userRole,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          // List of Profile Options
          Expanded(
            child: ListView(
              children: [
                ProfileOption(
                  icon: Icons.add_circle,
                  title: 'Add New Car',
                  subtitle: 'Expand your fleet easily',
                  index: 0,
                  isSelected: selectedOptionIndex == 0,
                  onTap: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReservationsList(
                                clientId:
                                    FirebaseAuth.instance.currentUser?.uid ??
                                        "",
                              )),
                    );
                  },
                ),
                ProfileOption(
                  icon: Icons.directions_car,
                  title: 'Manage Reservations',
                  subtitle: 'Handle bookings efficiently',
                  index: 2,
                  isSelected: selectedOptionIndex == 2,
                  onTap: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ManageReservationsScreen()),
                    );
                  },
                ),
                ProfileOption(
                  icon: Icons.payment,
                  title: 'Payments',
                  subtitle: 'Manage and track your payments',
                  index: 3,
                  isSelected: selectedOptionIndex == 3,
                  onTap: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentsScreen()),
                    );
                  },
                ),
                ProfileOption(
                  icon: Icons.favorite_border,
                  title: 'View Analytics',
                  subtitle: 'Track your agency performance',
                  index: 4,
                  isSelected: selectedOptionIndex == 4,
                  onTap: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FavoritesPage(
                              userId: FirebaseAuth.instance.currentUser?.uid ??
                                  "")),
                    );
                  },
                ),
                ProfileOption(
                  icon: Icons.settings,
                  title: 'Settings',
                  subtitle: 'Adjust your preferences',
                  index: 5,
                  isSelected: selectedOptionIndex == 5,
                  onTap: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  },
                ),
                ProfileOption(
                  icon: Icons.group,
                  title: 'Community',
                  subtitle: 'Connect with others',
                  index: 6,
                  isSelected: selectedOptionIndex == 6,
                  onTap: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CommunityPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int index;
  final bool isSelected;
  final Function(int) onTap;

  ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: ListTile(
        leading:
            Icon(icon, color: isSelected ? Colors.blueAccent : Colors.grey),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blueAccent : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () => onTap(index),
      ),
    );
  }
}

// Placeholder screens for navigation
class ManageReservationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Reservations')),
      body: Center(child: Text('Manage Reservations Screen')),
    );
  }
}

class PaymentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payments')),
      body: Center(child: Text('Payments Screen')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text('Settings Screen')),
    );
  }
}

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Community')),
      body: Center(child: Text('Community Page')),
    );
  }
}
