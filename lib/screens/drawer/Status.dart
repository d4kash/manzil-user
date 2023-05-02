import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Manzil/Network/connectivity_provider.dart';
import 'package:Manzil/Network/no_internet.dart';
import 'package:Manzil/helper/constants.dart';
import 'package:Manzil/model/rideHistoryModel.dart';
import 'package:Manzil/screens/vehicles/vehicleSelection.dart';
import 'package:intl/intl.dart';

import 'confirmBooking.dart';

class RideHistory extends StatefulWidget {
  @override
  State<RideHistory> createState() => _RideHistoryState();
}

class _RideHistoryState extends State<RideHistory> {
  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    // get the course document using a stream
    Stream<QuerySnapshot> rideDocStream = FirebaseFirestore.instance
        .collection('RequestedRide')
        .doc('$UID')
        .collection("booking")
        .snapshots();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Status".toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
                fontFamily: "SquidGames",
                letterSpacing: 3,
              )),
          leading: InkWell(
            child: Icon(Icons.arrow_back_ios),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => VehicleSelection()));
            },
          ),
        ),
        // body: fetchData(rideDocStream),
        body: Consumer<ConnectivityProvider>(
            builder: (consumerContext, model, child) {
          if (model.isOnline != null) {
            return model.isOnline ? fetchData(rideDocStream) : NoInternet();
          }
          ;
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> fetchData(
      Stream<QuerySnapshot<Object?>> rideDocStream) {
    return StreamBuilder<QuerySnapshot>(
        stream: rideDocStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // get course document
            // var courseDocument = snapshot.data!.docs as Map<String, dynamic>;
            // if (courseDocument != null) {
            // get sections from the document
            // var sections = courseDocument['RequestedRide'];

            // build list using names from sections
            return ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, int index) {
                // print(sections['Date']);
                String id = snapshot.data!.docs[index].id;

                return ListTile(
                    title: InkWell(
                  child: Card(
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white)),
                    color: Colors.orangeAccent.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${index + 1} : ${id}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookingConfirmation(
                                Name: id,
                              ))),
                ));
              },
            );
          } else {
            return Center(
              child: Container(
                height: 120,
                width: 200,
                child: Card(
                  color: Colors.deepOrange.shade100,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No booking yet!",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Give us a chance",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          // } else {
          //   return Container(
          //     child: Center(
          //       child: CircularProgressIndicator(),
          //     ),
        });
  }
}
