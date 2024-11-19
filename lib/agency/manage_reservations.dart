import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageReservationsScreen extends StatelessWidget {
  // Fonction pour annuler une réservation
  Future<void> _cancelReservation(
      BuildContext context, String reservationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reservationId)
          .update({'status': 'Cancelled'});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Reservation cancelled successfully!'),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to cancel reservation: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  // Fonction pour modifier une réservation (par exemple, changer la date ou le véhicule)
  Future<void> _updateReservation(
      BuildContext context, String reservationId) async {
    try {
      // Exemple de mise à jour d'un champ dans la réservation
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reservationId)
          .update({
        'reservationDate': Timestamp.fromDate(DateTime.now()
            .add(Duration(days: 1))), // Exemple de modification de la date
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Reservation updated successfully!'),
        backgroundColor: Colors.blue,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update reservation: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Reservations'),
        backgroundColor: Color.fromARGB(255, 41, 114, 255),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('reservations').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final reservationData = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reservationData.length,
            itemBuilder: (ctx, index) {
              final reservation = reservationData[index];
              final reservationId = reservation.id;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                elevation: 5,
                child: ListTile(
                  title: Text(
                    reservation['carName'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reserved by: ${reservation['customerName']}'),
                      Text(
                          'Reservation Date: ${reservation['reservationDate'].toDate()}'),
                      Text('Status: ${reservation['status']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bouton de mise à jour de la réservation
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _updateReservation(context, reservationId);
                        },
                      ),
                      // Bouton d'annulation de la réservation
                      IconButton(
                        icon: Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          _cancelReservation(context, reservationId);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
