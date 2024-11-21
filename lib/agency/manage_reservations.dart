import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageReservationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Reservations'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('reservations').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final reservations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              var reservation = reservations[index];
              var carName = reservation['carName'];
              var carModel = reservation['carModel'];
              var phone = reservation['phone'];
              var startDate = reservation['startDate'];
              var duration = reservation['duration'];
              var totalPrice = reservation['totalPrice'];
              var reservationDate = reservation['date'].toDate();

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  contentPadding: EdgeInsets.all(15),
                  title: Text('$carName ($carModel)'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start Date: $startDate'),
                      Text('Duration: $duration days'),
                      Text('Phone: $phone'),
                      Text('Total Price: AED $totalPrice'),
                      Text('Reservation Date: ${reservationDate.toLocal()}'),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'accept') {
                        _updateReservationStatus(reservation.id, 'Accepted');
                      } else if (value == 'cancel') {
                        _updateReservationStatus(reservation.id, 'Cancelled');
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'accept',
                        child: Text('Accept'),
                      ),
                      PopupMenuItem(
                        value: 'cancel',
                        child: Text('Cancel'),
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

  // Fonction pour mettre à jour le statut de la réservation
  Future<void> _updateReservationStatus(
      String reservationId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reservationId)
          .update({
        'status': status,
      });
      print('Reservation status updated to $status');
    } catch (e) {
      print('Failed to update status: $e');
    }
  }
}
