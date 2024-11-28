import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateAgencyStatus(String agencyId, String status) async {
    try {
      // Update the agency's status in Firestore
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
        title: Text("Admin Dashboard",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
      ),
      body: StreamBuilder<QuerySnapshot>(
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

          // List of agencies
          List<QueryDocumentSnapshot> agencies = snapshot.data!.docs;

          return ListView.builder(
            itemCount: agencies.length,
            itemBuilder: (context, index) {
              var agency = agencies[index].data() as Map<String, dynamic>;
              agency['id'] = agencies[index].id; // Include document ID

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    agency['name'] ?? 'No Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.indigo,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${agency['email']}'),
                        SizedBox(height: 4),
                        Text(
                            'Registration Number: ${agency['registrationNumber']}'),
                      ],
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Current status badge
                      Chip(
                        label: Text(agency['status'] ?? 'Pending'),
                        backgroundColor: agency['status'] == 'Accepted'
                            ? Colors.green
                            : agency['status'] == 'Rejected'
                                ? Colors.red
                                : Colors.orange,
                      ),
                      SizedBox(width: 8),
                      // Edit Icon Button
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Open dialog to change status
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title:
                                  Text('Modify Status for ${agency['name']}'),
                              content:
                                  Text('Select a new status for the agency:'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    updateAgencyStatus(
                                        agency['id'], 'Accepted');
                                    Navigator.pop(context); // Close dialog
                                  },
                                  child: Text('Accept'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    updateAgencyStatus(
                                        agency['id'], 'Rejected');
                                    Navigator.pop(context); // Close dialog
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
