import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: Center(
        child: Text('Transaction History Screen', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
