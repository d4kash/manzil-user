import 'package:Manzil/Network/connectivity_provider.dart';
import 'package:Manzil/Network/no_internet.dart';
import 'package:Manzil/helper/constants.dart';
import 'package:Manzil/screens/vehicles/vehicleSelection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'ontroller/controller.dart';

class PaymentInfo extends StatefulWidget {
  final String Distance;
  final String time_slot;
  final String vehicleType;
  PaymentInfo({
    Key? key,
    required this.Distance,
    required this.time_slot,
    required this.vehicleType,
  }) : super(key: key);

  @override
  State<PaymentInfo> createState() => _PaymentInfoState();
}

class _PaymentInfoState extends State<PaymentInfo> {
  bool isButtonDisabled = false;
  late Controller c;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    c = Get.put(Controller());

    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    var price = priceDecision();
    if (price == " not applicable distance for Auto" ||
        price == " not applicable distance for Toto" ||
        price == " not applicable distance for Pickup" ||
        price == " not applicable distance with Car" ||
        price == "null") {
      setState(() {
        isButtonDisabled = true;
      });
    } else {}
  }

  @override
  void dispose() {
    super.dispose();
    c.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    Date = formattedDate;
    print(formattedDate);
    DateTime now1 = DateTime.now();
    String formattedTime = DateFormat.Hms().format(now1);
    time = formattedTime;
    print(formattedTime);

    print(widget.Distance);
    print(widget.time_slot);
    print(widget.vehicleType);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Order Details".toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
              fontFamily: "SquidGames",
              letterSpacing: 3,
            )),
      ),
      body: Consumer<ConnectivityProvider>(
          builder: (consumerContext, model, child) {
        if (model.isOnline != null) {
          return Obx(() => model.isOnline
              ? c.isClicked.value == true
                  ? Center(
                      child: Container(
                        height: size.height / 20,
                        width: size.height / 20,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Body(size, context, c)
              : NoInternet());
        }
        ;
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }),
    ));
  }

  Widget Body(Size size, BuildContext context, Controller c) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          Text.rich(TextSpan(
              text: "${widget.vehicleType}".toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 25,
                fontFamily: "SquidGames",
                letterSpacing: 1,
              ))),
          Divider(
            height: 5,
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Distance: ",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
              Text("${widget.Distance}",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Time Slot",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
              Text(" ${widget.time_slot}",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Price:",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize:18)),
                  // SizedBox(width: Constants.width/8,),
                  SizedBox(width: Constants.width/3,),
              Expanded(
                child: Text("\u{20B9} $fare",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize:18)),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Fare:",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                  SizedBox(width: Constants.width/5,),
                  // SizedBox(width: Constants.width/46),
              Expanded(
                child: Text(" \u{20B9} $fare",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                  width: Constants.width/1,
                  height: 70,
                  child: isButtonDisabled
                      ? Container()
                      : CupertinoButton.filled(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('RENT NOW',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "SquidGames",
                                    letterSpacing: 1,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                          onPressed: () async {
                            c.isClicked.value = true;
                            await Future.delayed(Duration(milliseconds: 800));
                            c.isClicked.value = false;

                            saveTofirestore();
                            RidesaveTofirestore();
                            RidesaveTofirestoreColl();
                            final pref = await SharedPreferences.getInstance();
                            await pref.clear();

                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title:
                                          Text("Thank You for selecting us!"),
                                      content: Text(
                                          "we'll reach you in between ${widget.time_slot}!"),
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
            ),
          ),
        ],
      ),
    );
  }

  var fare = "null";

  String priceDecision() {
    if (widget.vehicleType == "Auto Booking") {
      return fare = autoPrice(widget.Distance);
    } else if (widget.vehicleType == "Toto Booking") {
      return fare = totoPrice(widget.Distance);
    } else if (widget.vehicleType == "Pickup Booking") {
      return fare = pickupPrice(widget.Distance);
    } else if (widget.vehicleType == "Scorpio Booking" ||
        widget.vehicleType == "Verna Booking" ||
        widget.vehicleType == "Dzire Booking" ||
        widget.vehicleType == "Bolero Booking") {
      return fare = CarPrice(widget.Distance);
    }
    return "Selected Distance cannot travelled by this vehicles";
  }

  String autoPrice(distance) {
    var dist = distance;
    switch (dist) {
      case "1 - 10 KM":
        return "250";

      case "1 - 20 KM":
        return "300";

      case "1 - 30 KM":
        return "350";

      case "1 - 40 KM":
        return "400";
    }
    return " not applicable distance for Auto";
  }

  String totoPrice(distance) {
    switch (distance) {
      case "1 - 10 KM":
        return "80";

      case "1 - 20 KM":
        return "120";

      case "1 - 30 KM":
        return "200";

      default:
    }
    return " not applicable distance for Toto";
  }

  String pickupPrice(distance) {
    switch (distance) {
      case "1 - 10 KM":
        return "300";

      case "1 - 20 KM":
        return "400";

      case "1 - 30 KM":
        return "400";

      case "1 - 50 KM":
        return "400";

      case "1 - 100 KM":
        return "600";

      case "1 - 150 KM":
        return "700";

      case "1 - 200 KM":
        return "800";

      case "1 - 250 KM":
        return "1000";

      default:
    }
    return " not applicable distance for Pickup";
  }

  String CarPrice(distance) {
    switch (distance) {
      case "1 - 100 KM":
        return "800 +  Fuel + Toll Tax ";

      case "1 - 150 KM":
        return "1000 +  Fuel + Toll Tax ";

      case "1 - 200 KM":
        return "1500 +  Fuel + Toll Tax ";

      case "1 - 250 KM":
        return "1800 +  Fuel + Toll Tax ";

      case "1 - 300 KM":
        return "2000 +  Fuel + Toll Tax ";

      case "1 - 350 KM":
        return "2200 +  Fuel + Toll Tax ";

      case "1 - 400 KM":
        return "2500 +  Fuel + Toll Tax ";
      case "1 - 50 KM":
        return "500 +  Fuel + Toll Tax ";
      case "1 - 20 KM":
        return "500 +  Fuel + Toll Tax ";

      default:
    }
    return " not applicable distance with Car";
  }

  String Date = "";

  String time = "";

  FirebaseFirestore _firebase = FirebaseFirestore.instance;

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
          'time_slot': '${widget.time_slot}',
          'distance': '${widget.Distance}',
          'payment_method': 'COD',
          'Address from map': '${_pref.getString('address')}',
          'vehicleType': '${widget.vehicleType}',
          'status': 'BOOKED',
          'uid': '$UID',
          "Date": Date,
          "Time": time,
        }
      ])
    }, SetOptions(merge: true));
  }

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
          'time_slot': '${widget.time_slot}',
          'distance': '${widget.Distance}',
          'payment_method': 'COD',
          'Address from map': '${_pref.getString('address')}',
          'vehicleType': '${widget.vehicleType}',
          'status': 'BOOKED',
          'uid': '$UID',
          "Date": Date,
          "Time": time,
        }
      ])
    }, SetOptions(merge: true));
  }

  void RidesaveTofirestore() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    _firebase
        .collection("RequestedRide")
        .doc(UID)
        .collection("booking")
        .doc("${_pref.getString('Name')}" " $Date" " $time")
        .set(
      {
        'RequestedRide': {
          'Address from map': '${_pref.getString('address')}',
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
          'time_slot': '${widget.time_slot}',
          'distance': '${widget.Distance}',
          'payment_method': 'COD',
          'vehicleType': '${widget.vehicleType}',
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
        'time_slot': '${widget.time_slot}',
        'distance': '${widget.Distance}',
        'payment_method': 'COD',
        'vehicleType': '${widget.vehicleType}',
        'status': 'waiting',
        'uid': '$UID',
        "Date": Date,
        "Time": time,
      },
    );
  }
}
