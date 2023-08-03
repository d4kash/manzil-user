import 'dart:ui';

import 'package:Manzil/screens/vehicles/slot_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Manzil/Network/connectivity_provider.dart';
import 'package:Manzil/Network/no_internet.dart';
import 'package:Manzil/helper/style.dart';
import 'package:Manzil/screens/timeSlot.dart';
import 'package:Manzil/widget/custom_text.dart';

import 'vehicles/ontroller/controller.dart';
import 'vehicles/ontroller/home_controller.dart';

class PickUpPage extends StatefulWidget {
  PickUpPage(
      {Key? key,
      required this.title,
      this.scaffoldState,
      required this.page_step})
      : super(key: key);
  final String title;
  final String page_step;
  final GlobalKey<ScaffoldState>? scaffoldState;

  @override
  _PickUpPageState createState() => _PickUpPageState();
}

class _PickUpPageState extends State<PickUpPage> {
  var scaffoldState = GlobalKey<ScaffoldState>();
  late TextEditingController PickUpControllerHome;
  late TextEditingController PickUpControllerLand;
  late TextEditingController PickUpControllerDistrict;
  late TextEditingController PickUpControllerPincode;
  late TextEditingController PhoneController;
  late TextEditingController NameController;
  Color darkBlue = Colors.black;
  Color grey = Colors.grey;
  GlobalKey<ScaffoldState>? scaffoldSate = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  late Controller c;
  final RegExp phoneRegex = new RegExp(r'^[6-9]\d{9}$');
  final RegExp aadharRegex =
      new RegExp(r'^([2-9]){1}\d([0-9]{3})\d([0-9]{3})\d([0-9]{2})$');
  //!Controller
  // late LocationController location;
  @override
  void initState() {
    PickUpControllerHome = TextEditingController();
    PickUpControllerLand = TextEditingController();
    PickUpControllerDistrict = TextEditingController();
    PickUpControllerPincode = TextEditingController();
    PhoneController = TextEditingController();
    NameController = TextEditingController();
    super.initState();
    c = Get.put(Controller());
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    scaffoldSate = widget.scaffoldState;
    // location = Get.put(LocationController());
    // getLocationPermission();
  }

  // getLocationPermission() async {
  //   await location.getLocation();
  // }

  @override
  void dispose() {
    super.dispose();
    PickUpControllerHome.dispose();
    PickUpControllerLand.dispose();
    PickUpControllerDistrict.dispose();
    PickUpControllerPincode.dispose();
    PhoneController.dispose();
    NameController.dispose();
    // location.dispose();
    // c.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
                fontFamily: "SquidGames",
                letterSpacing: 3,
              )),
        ),
        key: scaffoldState,
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
                    : stackMethod(size)
                : NoInternet());
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

  Stack stackMethod(Size size) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.circle,
              color: Colors.red,
              size: 12,
            ),
            SizedBox(width: 10),
            Text("${widget.page_step}".toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                  fontSize: 22,
                  fontFamily: "SquidGames",
                  letterSpacing: 2,
                )),
          ],
        ),
        SizedBox(height: size.height / 55),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Container(
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: grey.withOpacity(.8),
                      offset: Offset(3, 2),
                      blurRadius: 7)
                ]),
            child: ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              // controller: myscrollController,
              children: [
                Icon(
                  Icons.remove,
                  size: 40,
                  color: grey,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Container(
                      color: Colors.deepOrange.withOpacity(.3),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 16, bottom: 16, top: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "PICKUP LOCATION",
                              style: TextStyle(
                                color: black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: "SquidGames",
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              "Give us manzil !".toUpperCase(),
                              style: TextStyle(
                                color: black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: "SquidGames",
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Container(
                    color: grey.withOpacity(.3),
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r"[a-zA-Z]+|\s"))
                      ],
                      textInputAction: TextInputAction.go,
                      controller: NameController,
                      cursorColor: Colors.blue.shade900,
                      decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20, bottom: 15),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.person,
                            color: primary,
                          ),
                        ),
                        hintText: "Name",
                        hintStyle: TextStyle(
                            color: black,
                            fontSize: 18,
                            fontWeight: FontWeight.w100),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Container(
                    color: grey.withOpacity(.3),
                    child: TextField(
                      onTap: () async {},
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r"[a-zA-Z0-9]+|\s|\-|\,"))
                      ],
                      textInputAction: TextInputAction.go,
                      controller: PickUpControllerHome,
                      cursorColor: Colors.blue.shade900,
                      decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20, bottom: 15),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.location_on,
                            color: primary,
                          ),
                        ),
                        hintText: "Home",
                        hintStyle: TextStyle(
                            color: black,
                            fontSize: 18,
                            fontWeight: FontWeight.w100),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Container(
                    color: grey.withOpacity(.3),
                    child: TextField(
                      onTap: () async {},
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r"[a-zA-Z]+|\s|\-|\,"))
                      ],
                      textInputAction: TextInputAction.go,
                      controller: PickUpControllerLand,
                      cursorColor: Colors.blue.shade900,
                      decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20, bottom: 15),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.location_on,
                            color: primary,
                          ),
                        ),
                        hintText: "Landmark",
                        hintStyle: TextStyle(
                            color: black,
                            fontSize: 18,
                            fontWeight: FontWeight.w100),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Container(
                    color: grey.withOpacity(.3),
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r"[a-zA-Z]+|\s"))
                      ],
                      textInputAction: TextInputAction.go,
                      controller: PickUpControllerDistrict,
                      cursorColor: Colors.blue.shade900,
                      decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20, bottom: 15),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.location_on,
                            color: primary,
                          ),
                        ),
                        hintText: "District",
                        hintStyle: TextStyle(
                            color: black,
                            fontSize: 18,
                            fontWeight: FontWeight.w100),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Container(
                    color: grey.withOpacity(.3),
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))
                      ],
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textInputAction: TextInputAction.go,
                      controller: PickUpControllerPincode,
                      cursorColor: Colors.blue.shade900,
                      decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20, bottom: 15),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.location_on,
                            color: primary,
                          ),
                        ),
                        hintText: "Pincode",
                        hintStyle: TextStyle(
                            color: black,
                            fontSize: 18,
                            fontWeight: FontWeight.w100),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Container(
                    color: grey.withOpacity(.3),
                    child: Form(
                      autovalidateMode: AutovalidateMode.always,
                      child: TextFormField(
                        validator: (val) {
                          if (!phoneRegex.hasMatch(val!)) {
                            return "Not Valid";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        textInputAction: TextInputAction.go,
                        controller: PhoneController,
                        cursorColor: Colors.blue.shade900,
                        decoration: InputDecoration(
                          icon: Container(
                            margin: EdgeInsets.only(left: 20, bottom: 15),
                            width: 10,
                            height: 10,
                            child: Icon(
                              Icons.phone_android,
                              color: primary,
                            ),
                          ),
                          hintText: "Phone no",
                          hintStyle: TextStyle(
                              color: black,
                              fontSize: 18,
                              fontWeight: FontWeight.w100),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(15),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: customButton(size, c)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget customButton(Size size, Controller controller) {
    return GestureDetector(
      onTap: () async {
        if (PickUpControllerHome.text.isNotEmpty &&
            PickUpControllerLand.text.isNotEmpty &&
            PickUpControllerDistrict.text.isNotEmpty &&
            PickUpControllerPincode.text.isNotEmpty &&
            PhoneController.text.isNotEmpty &&
            PhoneController.text.length == 10 &&
            phoneRegex.hasMatch(PhoneController.text)) {
          controller.isClicked.value = true;
          // var a = await location.getLocation();
          // Get.defaultDialog(
          //   title: "Requested Permission",
          //   titleStyle: TextStyle(fontSize: 18),
          //   content: Text("Grant Location Permission ",
          //       style: TextStyle(fontSize: 15)),
          //   onConfirm: () async {
          //     await location.getLocation();
          //   },
          // );
          // print("a $a");
          await Future.delayed(Duration(milliseconds: 600));
          // print(location.address.value);
          // setState(() {
          //   _isLoading = true;
          // });
          print(controller.isClicked.value);
          SharedPreferences _pref = await SharedPreferences.getInstance();
          _pref.setString('Name', "${NameController.text}");
          _pref.setString('Pickup Home', "${PickUpControllerHome.text}");
          _pref.setString('Pickup Landmark', "${PickUpControllerLand.text}");
          _pref.setString(
              'Pickup District', "${PickUpControllerDistrict.text}");
          _pref.setString('Pickup Pincode', "${PickUpControllerPincode.text}");
          _pref.setString('Phone', "${PhoneController.text}");
          _pref.setString('address', "location.address.value");
          print("${_pref.getString('Pickup Home')}");
          print("${_pref.getString('Pickup Landmark')}");
          print("${_pref.getString('Pickup District')}");
          print("${_pref.getString('Pickup Pincode')}");

          await Future.delayed(Duration(milliseconds: 800));
          controller.isClicked.value = false;
          // setState(() {
          //   _isLoading = false;
          // });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SlotPicker(
                        vehicleType: '${widget.title}',
                      )));
        } else {
          print("Please fill form correctly");

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Fill all fields correctly!"),
          ));
        }
      },
      child: Container(
          height: size.height / 14,
          width: size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.yellow.shade600,
          ),
          alignment: Alignment.center,
          child: Text(
            "Set Pickup location",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }

  Widget field(
      Size size, String hintText, IconData icon, TextEditingController cont) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
        controller: cont,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
