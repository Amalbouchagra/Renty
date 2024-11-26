import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReservationsList extends StatelessWidget {
  final String clientId;

  // Constructeur avec le paramètre nommé `clientId`
  ReservationsList({required this.clientId});
  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Reservations'),
          backgroundColor: Color.fromARGB(255, 41, 114, 255),
        ),
        body: Center(
          child: Text(
            'You must be logged in to view reservations.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    print('Current User ID: $currentUserId');

    return Scaffold(
      appBar: AppBar(
        title: Text('My Reservations'),
        backgroundColor: Color.fromARGB(255, 41, 114, 255),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reservations')
            .where('clientId', isEqualTo: currentUserId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Error loading reservations: ${snapshot.error}');
            return Center(
              child: Text(
                'Error loading reservations: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final reservations = snapshot.data?.docs ?? [];
          print(
              'Retrieved reservations: ${reservations.map((doc) => doc.data()).toList()}');

          if (reservations.isEmpty) {
            return Center(
              child: Text(
                'No reservations found.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    reservation['carName'] ?? 'Unknown Car',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Model: ${reservation['carModel'] ?? 'N/A'}\n'
                    'Start Date: ${reservation['startDate'] ?? 'N/A'}\n'
                    'Duration: ${reservation['duration'] ?? 0} days\n'
                    'Price Per Day: AED ${reservation['pricePerDay'] ?? 0}\n'
                    'Total Price: AED ${reservation['totalPrice'] ?? 0}',
                  ),
                  trailing: Icon(Icons.directions_car),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
