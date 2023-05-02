import 'dart:async';

import 'package:Manzil/services/internetConn.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:Manzil/Network/connectivity_provider.dart';
import 'package:Manzil/Network/no_internet.dart';
import 'package:Manzil/chatCode/Authenticate/Methods.dart';
import 'package:Manzil/chatCode/Screens/HomeScreen.dart';
import 'package:Manzil/helper/constants.dart';
import 'package:Manzil/helper/style.dart';
import 'package:Manzil/model/model.dart';
import 'package:Manzil/screens/drawer/Status.dart';
import 'package:Manzil/screens/drawer/HistoryIndex.dart';
import 'package:Manzil/widget/ExitDialog.dart';
import '../destination.dart';
import 'carDetail.dart/VehicleDetails.dart';
import 'carSelect.dart';
import 'ontroller/controller.dart';

import 'package:permission_handler/permission_handler.dart';

class VehicleSelection extends StatefulWidget {
  const VehicleSelection({Key? key}) : super(key: key);

  @override
  _VehicleSelectionState createState() => _VehicleSelectionState();
}

String profName = "";
String profEmail = "";
// var rideHistory = [];

FirebaseFirestore _firebase = FirebaseFirestore.instance;

Future getName() async {
  DocumentSnapshot<Map<String, dynamic>> doc =
      await _firebase.collection("$DBUSER_PROFILE").doc("$UID").get();
  Model model = Model(name: doc['name'], email: doc['email']);
  profName = model.name;
  profEmail = model.email;
  // CircularProgressIndicator(color: Colors.deepOrange.shade500);
  // await Future.delayed(Duration(milliseconds: 500));
}

class _VehicleSelectionState extends State<VehicleSelection> {
  bool isOnline = true;
  // bool _isLoading = false;
  late Controller c;

  @override
  void initState() {
    super.initState();
    getName();
    c = Get.put(Controller());
    // requestLocationPermission();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  @override
  void dispose() {
    super.dispose();
    c.dispose();
  }

  Future<void> requestLocationPermission() async {
    final serviceStatusLocation = await Permission.locationWhenInUse.isGranted;

    bool isLocation = serviceStatusLocation == ServiceStatus.enabled;
    print(isLocation);
    final status = await Permission.locationWhenInUse.request();

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
      Get.defaultDialog();
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      Get.defaultDialog(
        title: "Requested Permission",
        titleStyle: TextStyle(fontSize: 18),
        content:
            Text("Grant Location Permission ", style: TextStyle(fontSize: 15)),
        onConfirm: () async {
          await openAppSettings();
        },
      );
      // await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // if (PermissionStatus.denied == true ||
    //     PermissionStatus.permanentlyDenied == true) {
    //   Get.defaultDialog(
    //     title: "Required Permission",
    //     titleStyle: TextStyle(fontSize: 15),
    //     content: Text("Location Permission is required for Location you"),
    //     onConfirm: () => requestLocationPermission(),
    //   );
    // }
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Image.asset(
                    "assets/images/mr1.png",
                    height: 35,
                  ),
                  Text("anzil",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "SquidGames",
                        letterSpacing: 3,
                      )),
                ],
              ),
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
            drawer: Drawer(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Welcome ! '.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 22,
                                fontFamily: "SquidGames",
                                letterSpacing: 5,
                                height: 3)),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text("$profName".toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white54,
                                    fontSize: 20,
                                    fontFamily: "SquidGames",
                                    letterSpacing: 5,
                                    height: 1)),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text("$profEmail",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white54,
                                  fontSize: 18,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.access_alarms_sharp),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Status'.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 18,
                              fontFamily: "SquidGames",
                              letterSpacing: 2,
                            )),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RideHistory()));
                      // Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.history_rounded),
                        SizedBox(width: 22),
                        Text('History'.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 18,
                              fontFamily: "SquidGames",
                              letterSpacing: 2,
                            )),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookStatus()));
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.history_rounded),
                        SizedBox(width: 22),
                        Text('Chat with us'.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 18,
                              fontFamily: "SquidGames",
                              letterSpacing: 2,
                            )),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatHomeScreen()));
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.logout_sharp),
                        SizedBox(
                          width: 22,
                        ),
                        Text('Logout'.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 18,
                              fontFamily: "SquidGames",
                              letterSpacing: 2,
                            )),
                      ],
                    ),
                    onTap: () {
                      logOut(context);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite, color: Colors.deepOrange),
                        // Image.asset(
                        //   "assets/images/sig.png",
                        //   height: 80,
                        // ),
                        SizedBox(
                          height: 5,
                        ),
                        DelayedDisplay(
                            delay: Duration(milliseconds: 600),
                            child: Text("RDS",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45,
                                  fontSize: 20,
                                  fontFamily: "SquidGames",
                                  letterSpacing: 3,
                                )))
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  List Vehicles = [
    "assets/images/vatara.png",
    "assets/images/tempo-re.png",
    "assets/images/electric_rikashaw.png",
    "assets/images/chotha_hathi.png"
  ];
  List VehiclesName = ["Cars Collection", "Auto", "Toto", "Pickup"];
  List VehiclesRate = [
    "\u{20B9} 800-3000",
    "\u{20B9} 300-800",
    "\u{20B9} 70-300",
    "\u{20B9} 500-1500"
  ];

  SingleChildScrollView Body(Size size, BuildContext context) {
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.circle,
                  color: Colors.red,
                  size: 12,
                ),
                SizedBox(width: 10),
                Text("STEP 1 ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                      fontSize: 20,
                      fontFamily: "SquidGames",
                      letterSpacing: 3,
                    )),
              ],
            ),
            SizedBox(height: size.height / 55),
            Text("Select Vehicle that drops you at your \"manzil\" ",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black26,
                    fontSize: 17)),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 5),
              child: SingleChildScrollView(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: Vehicles.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Row(
                          children: [
                            Row(children: [
                              OpenContainer(
                                  transitionType:
                                      ContainerTransitionType.fadeThrough,
                                  closedColor: Theme.of(context).cardColor,
                                  closedElevation: 0.0,
                                  openElevation: 4.0,
                                  transitionDuration:
                                      Duration(milliseconds: 800),
                                  closedBuilder: (BuildContext context,
                                      void Function() action) {
                                    return Container(
                                        height: 180,
                                        width: 180,
                                        color: Colors.grey.shade100,
                                        child: ImageContainer(
                                            "${Vehicles[index]}"));
                                  },
                                  openBuilder: (BuildContext context, action) {
                                    if (index == 0) {
                                      return CarSelect();
                                    } else {
                                      return VehiclesDetails(
                                        image: Vehicles[index],
                                        index: index,
                                        VehicleDetails: VehiclesName[index],
                                        VehicleRate: VehiclesRate[index],
                                      );
                                    }
                                  }),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${VehiclesName[index]}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${VehiclesRate[index]}",
                                      style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 19,
                                        fontFamily: "SquidGames",
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                        child: CustomBtn(),
                                        onTap: () async {
                                          // setState(() {
                                          //   _isLoading = true;
                                          // });
                                          c.isClicked.value = true;
                                          await Future.delayed(
                                              Duration(milliseconds: 500));
                                          // setState(() {
                                          //   _isLoading = false;
                                          // });
                                          c.isClicked.value = false;
                                          switch (index) {
                                            case 0:
                                              Get.to(() => CarSelect(),
                                                  transition:
                                                      Transition.cupertino);
                                              break;
                                            case 1:
                                              Get.to(
                                                  () => DestinationPage(
                                                        title: 'Auto Booking',
                                                        page_step: 2,
                                                      ),
                                                  transition:
                                                      Transition.cupertino);

                                              break;
                                            case 2:
                                              Get.to(
                                                  () => DestinationPage(
                                                        title: 'Toto Booking',
                                                        page_step: 2,
                                                      ),
                                                  transition:
                                                      Transition.cupertino);

                                              break;
                                            case 3:
                                              Get.to(
                                                  () => DestinationPage(
                                                        title: 'Pickup Booking',
                                                        page_step: 2,
                                                      ),
                                                  transition:
                                                      Transition.cupertino);

                                              break;
                                            default:
                                          }
                                        }),
                                  ],
                                ),
                              ),
                            ]),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CustomBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Container(
            height: 50,
            width: 110,
            color: Colors.yellow.shade600,
            child: Center(
                child: Text(
              "RENT",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                fontFamily: "SquidGames",
                letterSpacing: 2,
              ),
            ))),
      ),
    );
  }

  Container ImageContainer(String path) =>
      Container(child: Image.asset("$path"));
}
