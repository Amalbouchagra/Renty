import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int totalReservations = 0;
  double totalRevenue = 0;
  Map<String, int> carReservations = {};

  @override
  void initState() {
    super.initState();
    _fetchAnalyticsData();
  }

  // Fonction pour récupérer les données d'analyse depuis Firestore
  Future<void> _fetchAnalyticsData() async {
    try {
      QuerySnapshot reservationSnapshot =
          await FirebaseFirestore.instance.collection('reservations').get();

      totalReservations = reservationSnapshot.docs.length;
      totalRevenue = 0;
      carReservations.clear();

      // Traitement des données des réservations
      for (var doc in reservationSnapshot.docs) {
        double pricePerDay = doc['pricePerDay'];
        int duration = doc['duration'];
        double totalPrice = pricePerDay * duration;
        totalRevenue += totalPrice;

        String carName = doc['carName'];
        if (carReservations.containsKey(carName)) {
          carReservations[carName] = carReservations[carName]! + 1;
        } else {
          carReservations[carName] = 1;
        }
      }

      setState(() {});
    } catch (e) {
      print("Failed to fetch analytics data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Analytics'),
      ),
      body: totalReservations == 0
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Reservations: $totalReservations',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Total Revenue: AED ${totalRevenue.toStringAsFixed(2)}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Reservations by Car:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    _buildCarReservationChart(),
                    SizedBox(height: 20),
                    _buildCarReservationList(),
                  ],
                ),
              ),
            ),
    );
  }

  // Fonction pour construire un graphique des réservations par voiture
  Widget _buildCarReservationChart() {
    return carReservations.isEmpty
        ? Center(child: Text('No data available'))
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                barGroups: carReservations.entries
                    .map((entry) => BarChartGroupData(
                          x: carReservations.keys.toList().indexOf(entry.key),
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.toDouble(),
                              color: Colors.blue,
                              width: 20,
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
          );
  }

  // Fonction pour afficher la liste des réservations par voiture
  Widget _buildCarReservationList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: carReservations.entries
          .map(
            (entry) => ListTile(
              title: Text(entry.key),
              subtitle: Text('Reservations: ${entry.value}'),
            ),
          )
          .toList(),
    );
  }
}
