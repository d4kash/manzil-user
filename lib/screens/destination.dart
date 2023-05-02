import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Manzil/Network/connectivity_provider.dart';
import 'package:Manzil/Network/no_internet.dart';
import 'package:Manzil/helper/style.dart';
import 'package:Manzil/screens/pickup.dart';

import 'vehicles/ontroller/controller.dart';

class DestinationPage extends StatefulWidget {
  DestinationPage(
      {Key? key,
      required this.title,
      this.scaffoldState,
      required this.page_step})
      : super(key: key);
  final String title;
  final int page_step;
  final GlobalKey<ScaffoldState>? scaffoldState;

  @override
  _DestinationPageState createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  var scaffoldState = GlobalKey<ScaffoldState>();

  late TextEditingController destinationControllerHome;
  late TextEditingController destinationControllerLand;
  late TextEditingController destinationControllerDistrict;
  late TextEditingController destinationControllerPincode;
  Color darkBlue = Colors.black;
  Color grey = Colors.grey;
  GlobalKey<ScaffoldState>? scaffoldSate = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  late Controller c;
  @override
  void initState() {
    destinationControllerHome = TextEditingController();
    destinationControllerLand = TextEditingController();
    destinationControllerDistrict = TextEditingController();
    destinationControllerPincode = TextEditingController();
    super.initState();
    c = Get.put(Controller());
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();

    scaffoldSate = widget.scaffoldState;
  }

  @override
  void dispose() {
    super.dispose();
    destinationControllerHome.dispose();
    destinationControllerDistrict.dispose();
    destinationControllerLand.dispose();
    destinationControllerPincode.dispose();
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
                  : stackMethod(size, c)
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

  Stack stackMethod(Size size, Controller controll) {
    return Stack(
      children: <Widget>[
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.circle,
              color: Colors.red,
              size: 12,
            ),
            SizedBox(width: 10),
            Text("STEP ${widget.page_step} ",
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
                              "Destination Location".toUpperCase(),
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
                            RegExp(r"[a-zA-Z0-9]+|\s|\-|\,"))
                      ],
                      textInputAction: TextInputAction.go,
                      controller: destinationControllerHome,
                      cursorColor: Colors.deepOrange,
                      decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20, bottom: 15),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.home,
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
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r"[a-zA-Z]+|\s|\-|\,"))
                      ],
                      textInputAction: TextInputAction.go,
                      controller: destinationControllerLand,
                      cursorColor: Colors.deepOrange,
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
                      controller: destinationControllerDistrict,
                      cursorColor: Colors.deepOrange,
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
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.go,
                      controller: destinationControllerPincode,
                      cursorColor: Colors.deepOrange,
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
                    child: customButton(size, controll)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget customButton(Size size, Controller controller) {
    return InkWell(
      onTap: () async {
        if (destinationControllerHome.text.isNotEmpty &&
            destinationControllerLand.text.isNotEmpty &&
            destinationControllerDistrict.text.isNotEmpty &&
            destinationControllerPincode.text.isNotEmpty &&
            destinationControllerPincode.text.length == 6) {
          // setState(() {
          //   _isLoading = true;
          // });
          controller.isClicked.value = true;
          // await Future.delayed(Duration(milliseconds: 800));
          print(controller.isClicked.value);
          SharedPreferences _pref = await SharedPreferences.getInstance();
          _pref.setString('Home', "${destinationControllerHome.text}");
          _pref.setString('Landmark', "${destinationControllerLand.text}");
          _pref.setString('District', "${destinationControllerDistrict.text}");
          _pref.setString('Pincode', "${destinationControllerPincode.text}");
          print("${_pref.getString('Home')}");
          print("${_pref.getString('Landmark')}");
          print("${_pref.getString('District')}");
          print("${_pref.getString('Pincode')}");
          await Future.delayed(Duration(milliseconds: 700));
          controller.isClicked.value = false;
          // setState(() {
          //   _isLoading = false;
          // });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PickUpPage(
                        title: widget.title,
                        page_step: "Step ${widget.page_step + 1}",
                      )));
        } else {
          print("Please fill form correctly");
          // Fluttertoast.showToast(msg: "Please Fill all feilds correctly!");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please Fill all feilds correctly!"),
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
            "Set Destination",
            style: TextStyle(
              color: Colors.white,
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
