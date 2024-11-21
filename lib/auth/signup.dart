import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:renty/auth/login.dart';
import 'package:renty/styles/stylesauth.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _registrationNumber = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _selectedRole = 'User'; // Default role is 'User'

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create a new user in Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text,
          password: _password.text,
        );

        // Add user or agency data to Firestore
        await FirebaseFirestore.instance
            .collection('users') // Single collection for both roles
            .doc(userCredential.user!.uid)
            .set({
          'name': _name.text,
          'email': _email.text,
          'role': _selectedRole,
          if (_selectedRole != 'Admin')
            'phone': _phone.text, // Only for User and Agency
          if (_selectedRole == 'Agency') ...{
            'registrationNumber': _registrationNumber.text, // Only for Agency
            'status': 'Pending', // Add status 'Pending' for agencies
          },
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$_selectedRole account created successfully!'),
        ));

        // Clear fields and navigate back or reset
        _formKey.currentState!.reset();
        setState(() {
          _selectedRole = 'User'; // Reset to 'User' after registration
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Text("Signup",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: kInputDecoration(
                  labelText: 'Select Role',
                  icon: Icons.person,
                ),
                items: ['User', 'Agency', 'Admin'] // Added Admin role
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _name,
                decoration:
                    kInputDecoration(labelText: 'Name', icon: Icons.person),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _email,
                decoration:
                    kInputDecoration(labelText: 'Email', icon: Icons.email),
                validator: (value) =>
                    !value!.contains('@') ? 'Please enter a valid email' : null,
              ),
              const SizedBox(height: 16.0),
              // Display phone number field only if the role is not Admin
              if (_selectedRole != 'Admin') ...[
                TextFormField(
                  controller: _phone,
                  decoration:
                      kInputDecoration(labelText: 'Phone', icon: Icons.phone),
                  validator: (value) => value!.length < 8
                      ? 'Please enter a valid phone number'
                      : null,
                ),
              ],
              if (_selectedRole == 'Agency') ...[
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _registrationNumber,
                  decoration: kInputDecoration(
                      labelText: 'Registration Number', icon: Icons.numbers),
                  validator: (value) => value!.isEmpty
                      ? 'Please enter the registration number'
                      : null,
                ),
              ],
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _password,
                decoration:
                    kInputDecoration(labelText: 'Password', icon: Icons.lock),
                obscureText: true,
                validator: (value) => value!.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _confirmPassword,
                decoration: kInputDecoration(
                    labelText: 'Confirm Password', icon: Icons.lock),
                obscureText: true,
                validator: (value) =>
                    value != _password.text ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                style: kButtonStyle,
                child: const Text('Create Account'),
              ),
              SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Text(
                    "have an account?Log in here",
                    style: linkTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
