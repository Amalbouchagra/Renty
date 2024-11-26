import 'package:flutter/material.dart';
import 'package:renty/agency/AnalyticsScreen.dart';
import 'package:renty/agency/CarsListScreen.dart';
import 'package:renty/agency/add_car_screen.dart';
import 'package:renty/agency/manage_reservations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AgencyDashboardScreen(),
    );
  }
}

class AgencyDashboardScreen extends StatefulWidget {
  @override
  _AgencyDashboardScreenState createState() => _AgencyDashboardScreenState();
}

class _AgencyDashboardScreenState extends State<AgencyDashboardScreen> {
  // State variables
  String userName = 'John Doe'; // Exemple de nom par défaut
  String userRole = 'Admin'; // Exemple de rôle par défaut
  int selectedOptionIndex = -1;

  // Function to handle tap on options
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
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black),
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
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      userRole,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // List of options
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
                      MaterialPageRoute(builder: (context) => AddCarScreen()),
                    );
                  },
                ),
                ProfileOption(
                  icon: Icons.directions_car,
                  title: 'List Car',
                  subtitle: 'Showcase your available cars',
                  index: 1,
                  isSelected: selectedOptionIndex == 1,
                  onTap: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CarListScreen()),
                    );
                  },
                ),
                ProfileOption(
                  icon: Icons.manage_accounts,
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => PaymentsScreen()),
                    // );
                  },
                ),
                ProfileOption(
                  icon: Icons.analytics,
                  title: 'View Analytics',
                  subtitle: 'Track your agency performance',
                  index: 4,
                  isSelected: selectedOptionIndex == 4,
                  onTap: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AnalyticsScreen()),
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => SettingsScreen()),
                    // );
                  },
                ),
                ProfileOption(
                  icon: Icons.group,
                  title: 'Community',
                  subtitle: 'Connect with others',
                  index: 6,
                  isSelected: selectedOptionIndex == 6,
                  onTap: (index) {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => CommunityPage()),
                    // );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.notifications),
      //       label: 'Notifications',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
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
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: () {
        onTap(index);
      },
    );
  }
}
