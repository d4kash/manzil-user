import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Manzil/helper/constants.dart';
import 'package:Manzil/screens/vehicles/vehicleSelection.dart';

class TimeSlot extends StatelessWidget {
  TimeSlot({
    Key? key,
    required this.vehicleType,
  }) : super(key: key);
  String _slot = "";
  int rideCount = 0;
  final String vehicleType;

  String Date = "";

  String time = "";

  FirebaseFirestore _firebase = FirebaseFirestore.instance;
  void saveChoosedTime(int index) {
    _slot = TIME_SLOT.elementAt(index);
  }

  void saveTofirestore() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    _firebase.collection("$DBUSER").doc(UID).set({
      'ride': FieldValue.arrayUnion([
        {
          'dest': {
            'Dest Home': '${_pref.getString('Home')}',
            'Dest Landmark': '${_pref.getString('Landmark')}',
            'Dest District': '${_pref.getString('District')}',
            'Dest Pincode': '${_pref.getString('Pincode')}',
          },
          'pickup': {
            'pickup Home': '${_pref.getString('Pickup Home')}',
            'pickup Landmark': '${_pref.getString('Pickup Landmark')}',
            'pickup District': '${_pref.getString('Pickup District')}',
            'pickup Pincode': '${_pref.getString('Pickup Pincode')}',
            'phone': '${_pref.getString('Phone')}',
          },
          'Name': '${_pref.getString('Name')}',
          'time_slot': '$_slot',
          'payment_method': 'COD',
          'vehicleType': '$vehicleType',
          'status': 'waiting',
          'uid': '$UID',
          "Date": Date,
          "Time": time,
        }
      ])
    }, SetOptions(merge: true));
  } //requested ride db

  void saveTofirestoreForHistroy() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    _firebase.collection("userHistory").doc(UID).set({
      'ride': FieldValue.arrayUnion([
        {
          'dest': {
            'Dest Home': '${_pref.getString('Home')}',
            'Dest Landmark': '${_pref.getString('Landmark')}',
            'Dest District': '${_pref.getString('District')}',
            'Dest Pincode': '${_pref.getString('Pincode')}',
          },
          'pickup': {
            'pickup Home': '${_pref.getString('Pickup Home')}',
            'pickup Landmark': '${_pref.getString('Pickup Landmark')}',
            'pickup District': '${_pref.getString('Pickup District')}',
            'pickup Pincode': '${_pref.getString('Pickup Pincode')}',
            'phone': '${_pref.getString('Phone')}',
          },
          'Name': '${_pref.getString('Name')}',
          'time_slot': '$_slot',
          'payment_method': 'COD',
          'vehicleType': '$vehicleType',
          'status': 'waiting',
          'uid': '$UID',
          "Date": Date,
          "Time": time,
        }
      ])
    }, SetOptions(merge: true));
  } //requested ride db

  void RidesaveTofirestore() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    _firebase
        .collection("RequestedRide")
        .doc(UID)
        .collection("booking")
        .doc("${_pref.getString('Name')}" "$Date" "$time")
        .set(
      {
        'RequestedRide': {
          'Dest Home': '${_pref.getString('Home')}',
          'Dest Landmark': '${_pref.getString('Landmark')}',
          'Dest District': '${_pref.getString('District')}',
          'Dest Pincode': '${_pref.getString('Pincode')}',
          'pickup Home': '${_pref.getString('Pickup Home')}',
          'pickup Landmark': '${_pref.getString('Pickup Landmark')}',
          'pickup District': '${_pref.getString('Pickup District')}',
          'pickup Pincode': '${_pref.getString('Pickup Pincode')}',
          'phone': '${_pref.getString('Phone')}',
          'Name': '${_pref.getString('Name')}',
          'time_slot': '$_slot',
          'payment_method': 'COD',
          'vehicleType': '$vehicleType',
          'status': 'waiting',
          'uid': '$UID',
          "Date": Date,
          "Time": time,
        }
      },
    );
  }

  void RidesaveTofirestoreColl() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    _firebase.collection("RequestedRide").doc(UID).set(
      {
        'Name': '${_pref.getString('Name')}',
        'time_slot': '$_slot',
        'payment_method': 'COD',
        'vehicleType': '$vehicleType',
        'status': 'waiting',
        'uid': '$UID',
        "Date": Date,
        "Time": time,
      },
    );
  }

  // Future getRideCount() async {
  //   await _firebase
  //       .collection("${DBUSER}")
  //       .doc(UID)
  //       .get()
  //       .then((value) => rideHistory.add(value.data()!['ride']));
  //   // rideHistory = documentSnapshot.data['ride'];
  //   rideCount = rideHistory.length;
  //   print(rideCount);
  // }

  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    Date = formattedDate;
    print(formattedDate);
    DateTime now1 = DateTime.now();
    String formattedTime = DateFormat.Hms().format(now1);
    time = formattedTime;
    print(formattedTime);
    return Scaffold(
        appBar: AppBar(
          title: Text("Time Slot"),
        ),
        body: SafeArea(
          child: GridView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: TIME_SLOT.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) => InkWell(
                    child: Card(
                      elevation: 8,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      // color: Colors.deepPurpleAccent[100]!.withOpacity(0.3),
                      child: GridTile(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${TIME_SLOT.elementAt(index)}",
                                style: TextStyle(
                                    color: Colors.red.shade400,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text("Available"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      saveChoosedTime(index);
                      print(_slot);

                      Future.delayed(Duration(seconds: 3));
                      CircularProgressIndicator();
                      saveTofirestore();
                      RidesaveTofirestore();
                      RidesaveTofirestoreColl();
                      final pref = await SharedPreferences.getInstance();
                      await pref.clear();

                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Thank You for selecting us!"),
                                content:
                                    Text("we'll reach you between $_slot!"),
                                actions: [
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VehicleSelection()));
                                    },
                                  )
                                ],
                              ));
                    },
                  )),
        ));
  }
}
