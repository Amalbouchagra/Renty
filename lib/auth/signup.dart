// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:renty/clients/styles/stylesauth.dart';

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup Options")),
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          shrinkWrap: true,
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Signup as User"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserSignup()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text("Signup as Agency"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AgencySignup()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// User Signup Form
class UserSignup extends StatefulWidget {
  const UserSignup({Key? key}) : super(key: key);

  @override
  _UserSignupState createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() async {
    return users.add({
      'name': _name.text,
      'email': _email.text,
      'phone': _phone.text,
      'password': _password.text,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User Account created successfully!'),
      ));
    }).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> _registerWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text,
          password: _password.text,
        );
        await addUser();
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
      appBar: AppBar(title: Text("User Signup")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              Center(
                child: Text("Signup as a User",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _name,
                decoration:
                    kInputDecoration(labelText: 'Name', icon: Icons.person),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _email,
                decoration:
                    kInputDecoration(labelText: 'Email', icon: Icons.email),
                validator: (value) =>
                    !value!.contains('@') ? 'Please enter a valid email' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _phone,
                decoration:
                    kInputDecoration(labelText: 'Phone', icon: Icons.phone),
                validator: (value) => value!.length < 8
                    ? 'Please enter a valid phone number'
                    : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _password,
                decoration:
                    kInputDecoration(labelText: 'Password', icon: Icons.lock),
                obscureText: true,
                validator: (value) => value!.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _confirmPassword,
                decoration: kInputDecoration(
                    labelText: 'Confirm Password', icon: Icons.lock),
                obscureText: true,
                validator: (value) =>
                    value != _password.text ? 'Passwords do not match' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerWithEmailAndPassword,
                style: kButtonStyle,
                child: Text('Create User Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Agency Signup Form
class AgencySignup extends StatefulWidget {
  const AgencySignup({Key? key}) : super(key: key);

  @override
  _AgencySignupState createState() => _AgencySignupState();
}

class _AgencySignupState extends State<AgencySignup> {
  final TextEditingController _agencyName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _registrationNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  CollectionReference agencies =
      FirebaseFirestore.instance.collection('agencies');

  Future<void> addAgency() async {
    return agencies.add({
      'agencyName': _agencyName.text,
      'email': _email.text,
      'address': _address.text,
      'registrationNumber': _registrationNumber.text,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Agency Account created successfully!'),
      ));
    }).catchError((error) => print("Failed to add agency: $error"));
  }

  Future<void> _registerAgencyWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text,
          password: _password.text,
        );
        await addAgency();
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
      appBar: AppBar(title: Text("Agency Signup")),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              Center(
                child: Text("Signup as an Agency",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _agencyName,
                decoration: kInputDecoration(
                    labelText: 'Agency Name', icon: Icons.business),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the agency name' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _email,
                decoration:
                    kInputDecoration(labelText: 'Email', icon: Icons.email),
                validator: (value) =>
                    !value!.contains('@') ? 'Please enter a valid email' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _address,
                decoration: kInputDecoration(
                    labelText: 'Address', icon: Icons.location_on),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the address' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _registrationNumber,
                decoration: kInputDecoration(
                    labelText: 'Registration Number', icon: Icons.numbers),
                validator: (value) => value!.isEmpty
                    ? 'Please enter the registration number'
                    : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _password,
                decoration:
                    kInputDecoration(labelText: 'Password', icon: Icons.lock),
                obscureText: true,
                validator: (value) => value!.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerAgencyWithEmailAndPassword,
                style: kButtonStyle,
                child: Text('Create Agency Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
