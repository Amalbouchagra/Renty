import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renty/home/home.dart';

class ReservationDialog extends StatelessWidget {
  final Car car;

  ReservationDialog({required this.car});

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController startDateController = TextEditingController();
    final TextEditingController durationController = TextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reserve Car',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            // Display car details
            _buildCarInfo(),
            SizedBox(height: 20),
            // Phone number input
            _buildTextField(
              controller: phoneController,
              label: '+216 | Phone number',
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            // Start date input
            _buildDateInput(context, startDateController),
            SizedBox(height: 16),
            // Duration input
            _buildTextField(
              controller: durationController,
              label: 'Duration (Days)',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24),
            // Submit Button
            _buildSubmitButton(context, phoneController, startDateController,
                durationController),
          ],
        ),
      ),
    );
  }

  Widget _buildCarInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Car: ${car.name} (${car.model})',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800]),
        ),
        Text(
          'Price per day: AED ${car.pricePerDay.toStringAsFixed(2)}',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.green[600]),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 41, 114, 255)),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildDateInput(
      BuildContext context, TextEditingController startDateController) {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          startDateController.text =
              DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: startDateController,
          decoration: InputDecoration(
            labelText: 'Start Date',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    TextEditingController phoneController,
    TextEditingController startDateController,
    TextEditingController durationController,
  ) {
    return ElevatedButton(
      onPressed: () {
        _submitReservation(
          context,
          car,
          phoneController.text.trim(),
          startDateController.text.trim(),
          durationController.text.trim(),
        );
      },
      child: Text(
        'Submit Reservation',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 41, 114, 255),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        shadowColor: Color.fromARGB(255, 41, 114, 255).withOpacity(0.3),
      ),
    );
  }

  void _submitReservation(
    BuildContext context,
    Car car,
    String phone,
    String startDate,
    String durationStr,
  ) {
    final duration = int.tryParse(durationStr);

    if (phone.isEmpty || startDate.isEmpty || duration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly!')),
      );
      return;
    }

    // Send the reservation to Firestore
    FirebaseFirestore.instance.collection('reservations').add({
      'carName': car.name,
      'carModel': car.model,
      'pricePerDay': car.pricePerDay,
      'phone': phone,
      'startDate': startDate,
      'duration': duration,
      'totalPrice': car.pricePerDay * duration,
      'createdAt': DateTime.now(),
    }).then((_) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation submitted successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit reservation: $error')),
      );
    });
  }
}
