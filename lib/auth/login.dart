import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renty/admin/AdminDashboard.dart';
import 'package:renty/agency/agency_dashboard.dart';
import 'package:renty/auth/signup.dart';

import 'package:renty/clients/home_client.dart';

import 'package:renty/styles/stylesauth.dart';

class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Authentification de l'utilisateur
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Récupération des données utilisateur depuis Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          String role = userDoc['role'];
          String? status = userDoc.data().toString().contains('status')
              ? userDoc['status']
              : null;

          // Vérification du rôle
          if (role == 'Agency') {
            if (status == 'Accepted') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AgencyDashboardScreen()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Your account is not approved yet. Please contact support.'),
              ));
              FirebaseAuth.instance.signOut();
            }
          } else if (role == 'User') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeClient(
                        userId: '',
                      )),
            );
          } else if (role == 'Admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminDashboard()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Unknown role: $role'),
            ));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('No user data found'),
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 60), // Space for logo
              Image.asset(
                'assets/logo.jpeg',
                height: 100,
              ),
              SizedBox(height: 20),
              Text(
                "Welcome back to Renty",
                style: headingTextStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Sign in to continue",
                style: subheadingTextStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: _emailController,
                decoration: kInputDecoration(
                  labelText: 'Email',
                  icon: Icons.email,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: kInputDecoration(
                  labelText: 'Password',
                  icon: Icons.lock,
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Gestion du reset mot de passe
                  },
                  child: Text("Forgot Password?", style: linkTextStyle),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('LOGIN', style: buttonTextStyle),
                style: elevatedButtonStyle,
              ),
              SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                    );
                  },
                  child: Text(
                    "Don't have an account? Create a new account",
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
