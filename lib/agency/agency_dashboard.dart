import 'package:flutter/material.dart';
import 'package:renty/agency/CarsListScreen.dart';
import 'add_car_screen.dart';
import 'add_car_screen.dart';
import 'manage_reservations.dart';

class AgencyDashboardScreen extends StatefulWidget {
  @override
  _AgencyDashboardScreenState createState() => _AgencyDashboardScreenState();
}

class _AgencyDashboardScreenState extends State<AgencyDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agency Dashboard'),
        backgroundColor: const Color.fromARGB(255, 41, 114, 255),
        titleTextStyle: TextStyle(
          color: Colors.white, // Couleur du texte (ici blanc)
          fontSize: 22, // Taille du texte
          fontWeight: FontWeight.bold, // Poids du texte
        ),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Color.fromARGB(255, 255, 255, 255),
            ), // Icône de déconnexion
            tooltip: 'Logout', // Texte d'info-bulle
            onPressed: () {
              // Action à exécuter lors du clic sur l'icône
              print('Logout pressed');
              // Ajoutez ici la logique pour gérer la déconnexion
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome to Your Dashboard',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildDashboardCard(
                    icon: Icons.add_circle,
                    title: 'Add New Car',
                    subtitle: 'Expand your fleet easily',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddCarScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDashboardCard(
                    icon: Icons.add_circle,
                    title: 'List Car',
                    subtitle: 'Expand your fleet easily',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CarListScreen(), // Adjusted naming
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDashboardCard(
                    icon: Icons.manage_accounts,
                    title: 'Manage Reservations',
                    subtitle: 'Handle bookings efficiently',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManageReservationsScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Première carte: Paiement
                Expanded(
                  child: _buildDashboardCard(
                    icon: Icons.payment, // Icône de paiement
                    title: 'Payments',
                    subtitle: 'Manage and track your payments',
                    onTap: () {
                      // Appel à l'écran de paiement
                      // Décommentez cette ligne pour activer la navigation
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PaymentScreen(),
                      //   ),
                      // );
                    },
                  ),
                ),
                // Espace entre les cartes
                const SizedBox(width: 16),
                // Deuxième carte: Analytics
                Expanded(
                  child: _buildDashboardCard(
                    icon: Icons.analytics, // Icône d'analyse
                    title: 'View Analytics',
                    subtitle: 'Track your agency performance',
                    onTap: () {
                      // Appel à l'écran d'analytics
                      // Décommentez cette ligne pour activer la navigation
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => AnalyticsScreen(),
                      //   ),
                      // );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDashboardCard(
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'Adjust your preferences',
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => SettingsScreen()),
                      // );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(
            minWidth: 180,
            maxWidth: 200,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 40, color: const Color.fromARGB(255, 41, 114, 255)),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
