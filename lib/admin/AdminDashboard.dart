import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fonction pour mettre à jour le statut de l'agence
  Future<void> updateAgencyStatus(String agencyId, String status) async {
    try {
      await _firestore.collection('users').doc(agencyId).update({
        'status': status,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Agency status updated to $status')),
      );
    } catch (e) {
      print("Error updating agency status: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Flux Firestore pour suivre les modifications en temps réel
        stream: _firestore
            .collection('users')
            .where('role', isEqualTo: 'Agency')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No agencies found"));
          }

          // Liste des agences
          List<QueryDocumentSnapshot> agencies = snapshot.data!.docs;

          return ListView.builder(
            itemCount: agencies.length,
            itemBuilder: (context, index) {
              var agency = agencies[index].data() as Map<String, dynamic>;
              agency['id'] = agencies[index].id; // Inclure l'ID du document

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(agency['name'] ?? 'No Name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${agency['email']}'),
                      Text(
                          'Registration Number: ${agency['registrationNumber']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Affiche le statut actuel sous forme de badge
                      Chip(
                        label: Text(agency['status'] ?? 'Pending'),
                        backgroundColor: agency['status'] == 'Accepted'
                            ? Colors.green
                            : agency['status'] == 'Rejected'
                                ? Colors.red
                                : Colors.orange,
                      ),
                      SizedBox(
                          width: 8), // Espacement entre l'icône et le badge
                      // Icône Modifier
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Ouvre une boîte de dialogue pour changer le statut
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Modify Status'),
                              content:
                                  Text('Select a new status for the agency:'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    updateAgencyStatus(
                                        agency['id'], 'Accepted');
                                    Navigator.pop(
                                        context); // Ferme la boîte de dialogue
                                  },
                                  child: Text('Accept'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    updateAgencyStatus(
                                        agency['id'], 'Rejected');
                                    Navigator.pop(
                                        context); // Ferme la boîte de dialogue
                                  },
                                  child: Text('Reject'),
                                ),
                              ],
                            ),
                          );
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
