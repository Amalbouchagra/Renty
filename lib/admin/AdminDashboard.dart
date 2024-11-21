import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fonction pour mettre à jour le statut de l'agence
  Future<void> updateAgencyStatus(
      String agencyId, String status, String email) async {
    try {
      // Mise à jour du statut de l'agence dans Firestore
      await _firestore.collection('users').doc(agencyId).update({
        'status': status,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Agency status updated to $status')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }

  // Fonction pour récupérer les agences
  Future<List<Map<String, dynamic>>> _getAgencies() async {
    // Récupérer tous les utilisateurs depuis Firestore et filtrer par rôle 'Agency'
    QuerySnapshot snapshot = await _firestore.collection('users').get();

    // Filtrer pour ne récupérer que les utilisateurs ayant le rôle 'Agency'
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .where(
            (user) => user['role'] == 'Agency') // Filtrer sur le rôle 'Agency'
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // FutureBuilder pour afficher les agences
        future: _getAgencies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No agencies found"));
          }

          // Liste des agences
          List<Map<String, dynamic>> agencies = snapshot.data!;

          return ListView.builder(
            itemCount: agencies.length,
            itemBuilder: (context, index) {
              var agency = agencies[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(agency['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${agency['email']}'),
                      Text(
                          'Registration Number: ${agency['registrationNumber']}'),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(agency['status'] ?? 'Pending'),
                    backgroundColor: agency['status'] == 'Accepted'
                        ? Colors.green
                        : agency['status'] == 'Rejected'
                            ? Colors.red
                            : Colors.orange,
                  ),
                  onLongPress: () {
                    // Vérification du numéro d'enregistrement pour les agences
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Verify Agency Registration'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                'Registration Number: ${agency['registrationNumber']}'),
                            SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(
                                  labelText: 'Enter Verification Code'),
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Si l'agence est validée
                                    updateAgencyStatus(agency['id'], 'Accepted',
                                        agency['email']);
                                    Navigator.pop(
                                        context); // Fermer la boîte de dialogue
                                  },
                                  child: Text('Accept'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Si l'agence est rejetée
                                    updateAgencyStatus(agency['id'], 'Rejected',
                                        agency['email']);
                                    Navigator.pop(
                                        context); // Fermer la boîte de dialogue
                                  },
                                  child: Text('Reject'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
