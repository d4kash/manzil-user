import 'package:Manzil/Network/connectivity_provider.dart';
import 'package:Manzil/Network/no_internet.dart';
import 'package:Manzil/screens/vehicles/ontroller/controller.dart';
import 'package:Manzil/screens/vehicles/paymentPage.dart';
import 'package:Manzil/screens/vehicles/vehicleSelection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:Manzil/helper/constants.dart';

class SlotPicker extends StatefulWidget {
  final String vehicleType;
  SlotPicker({
    Key? key,
    required this.vehicleType,
  }) : super(key: key);
  @override
  State<SlotPicker> createState() =>
      _SlotPickerState(vehicleType: this.vehicleType);
}

class _SlotPickerState extends State<SlotPicker> {
  var _selectedValue = "No Pickup Time Selected";
  var _selectedDistance = "No Distance Selected";
  String vehicleType = "";
  //controller initialization
  late Controller c;

  _SlotPickerState({required this.vehicleType});
  //Firebase
  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print(vehicleType);
    c = Get.put(Controller());
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  String Date = "";

  String time = "";

  //Firebase

  @override
  Widget build(BuildContext context) {
    //controller

    //
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
    print(_selectedValue);
    print(_selectedDistance);
    return Scaffold(
      appBar: AppBar(
        title: Title(
            color: Colors.deepOrange,
            child: Text("Choose".toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "SquidGames",
                  letterSpacing: 3,
                ))),
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
                  : Body(size, context)
              : NoInternet());
        }
        ;
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }),
    );
  }

  Widget Body(Size size, BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Text('Select Time For Pickup',
            style: TextStyle(
                fontSize: 23,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Obx(
          () => Text('Time: ${c.selectedValue.value}'.toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                fontFamily: "SquidGames",
                letterSpacing: 1,
              )),
        ),
        SizedBox(height: 50),
        CupertinoButton.filled(
          child: Text('Time Slot Picker'.toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                fontFamily: "SquidGames",
                letterSpacing: 1,
              )),
          onPressed: () => c.showPicker(context),
        ),
        SizedBox(
          height: 20,
        ),
        Divider(),
        Text("Select distace from your location",
            style: TextStyle(
                fontSize: 23,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Obx(
          () => Text('Distance: ${c.selectedDistance.value}'.toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                fontFamily: "SquidGames",
                letterSpacing: 1,
              )),
        ),
        SizedBox(height: 50),
        CupertinoButton.filled(
          child: Text('Distance Picker'.toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                fontFamily: "SquidGames",
                letterSpacing: 1,
              )),
          onPressed: () => c.showDistancePicker(context),
        ),
        SizedBox(
          height: 40,
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 250,
              height: 70,
              child: CupertinoButton.filled(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Checkout'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "SquidGames",
                          letterSpacing: 1,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
                onPressed: () async {
                  c.isClicked.value = true;
                  await Future.delayed(Duration(milliseconds: 800));
                  c.isClicked.value = false;
                  Get.to(PaymentInfo(
                    Distance: c.selectedDistance.value,
                    time_slot: c.selectedValue.value,
                    vehicleType: vehicleType,
                  ));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
