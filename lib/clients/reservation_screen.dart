import 'package:flutter/material.dart';

class ReservationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation'),
      ),
      body: Center(
        child: Text('Reservation Screen', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
