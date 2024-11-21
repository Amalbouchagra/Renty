import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:renty/agency/add_car_screen.dart';
import 'clients/home.dart';

import 'package:renty/agency/agency_dashboard.dart';

import 'auth/login.dart';
import 'auth/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCOTUIpOY-OHabR6qy94yqDkbBZXnYbm5g",
      appId: "com.example.renty",
      messagingSenderId: "626975763183",
      projectId: "renty-90dfc",
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('=============User is currently signed out!');
      } else {
        print('==================User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
        routes: {
          "signup": (context) => Signup(),
          "Login": (context) => Login(),
          "Home": (context) => Home(),
          "AgencyDashboardScreen": (context) => AgencyDashboardScreen(),
          "AddCarScreen": (context) => AddCarScreen(),
        });
  }
}
