import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Manzil/chatCode/Authenticate/LoginScree.dart';
import 'package:Manzil/chatCode/Screens/HomeScreen.dart';
import 'package:Manzil/screens/vehicles/vehicleSelection.dart';

class Authenticate extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return VehicleSelection();
    } else {
      return LoginScreen();
    }
  }
}
