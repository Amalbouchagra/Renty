import 'package:flutter/material.dart';

// Custom input decoration style for consistent form field styling
InputDecoration kInputDecoration({
  required String labelText,
  required IconData icon,
}) {
  return InputDecoration(
    labelText: labelText,
    prefixIcon: Icon(icon, color: Colors.blueAccent),
    filled: true,
    fillColor: Colors.white,
    contentPadding:
        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.blueAccent),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.blueAccent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.blue),
    ),
  );
}

// Custom button style for consistent button appearance
ButtonStyle kButtonStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.symmetric(vertical: 10.0),
  backgroundColor: Colors.blueAccent,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
);

// styles page login
// Couleurs de l'application
const Color primaryColor = Color.fromARGB(255, 41, 114, 255);
const Color backgroundColor = Colors.white;
const Color greyColor = Colors.grey;

// Styles de texte
const TextStyle headingTextStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  color: primaryColor,
);

const TextStyle subheadingTextStyle = TextStyle(
  fontSize: 10,
  color: greyColor,
);

const TextStyle buttonTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle linkTextStyle = TextStyle(
  color: primaryColor,
  fontWeight: FontWeight.w500,
);

final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  minimumSize: const Size(150, 40), // Taille minimale du bouton
  padding: const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 10.0), // Padding modifié pour un bouton plus petit
  textStyle: const TextStyle(fontSize: 12.0), // Réduire la taille du texte
  backgroundColor: primaryColor, // Couleur de fond
);
