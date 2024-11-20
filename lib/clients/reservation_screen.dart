import 'package:flutter/material.dart';

class ReservationScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Car model field
              TextFormField(
                controller: _carModelController,
                decoration: InputDecoration(
                  labelText: 'Car Model',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the car model';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Start date field
              TextFormField(
                controller: _startDateController,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    _startDateController.text =
                        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a start date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Duration field
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: 'Duration (in days)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the duration';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid number of days';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Submit button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String carModel = _carModelController.text;
                    String startDate = _startDateController.text;
                    String duration = _durationController.text;

                    // Show a confirmation message
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Reservation Confirmed'),
                        content: Text(
                          'You have reserved a $carModel starting from $startDate for $duration day(s).',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );

                    // Clear the form fields
                    _carModelController.clear();
                    _startDateController.clear();
                    _durationController.clear();
                  }
                },
                child: Text('Reserve Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
