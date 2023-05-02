import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../destination.dart';
import '../carSelect.dart';
import '../vehicleSelection.dart';

/// Wrapper for stateful functionality to provide onInit calls in stateles widget
class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Widget child;
  const StatefulWrapper({required this.onInit, required this.child});
  @override
  _StatefulWrapperState createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    if (widget.onInit != null) {
      widget.onInit();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class VehiclesDetails extends StatelessWidget {
  VehiclesDetails({
    Key? key,
    required this.image,
    required this.VehicleDetails,
    required this.VehicleRate,
    required this.index,
  }) : super(key: key);
  final String image;
  final String VehicleDetails;
  final String VehicleRate;
  final int index;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("DETAILS",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
              fontFamily: "SquidGames",
              letterSpacing: 2,
            )),
        // leading: InkWell(
        //     child: Icon(Icons.arrow_back_ios),
        //     onTap: () => Navigator.pushReplacement(context,
        //         (MaterialPageRoute(builder: (context) => VehicleSelection())))),
      ),
      body: Column(
        children: [
          Stack(alignment: Alignment.bottomLeft, children: [
            Card(child: ImageContainer("$image")),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text("$VehicleDetails".toUpperCase(),
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xFFCE546D),
                    fontWeight: FontWeight.w300,
                    fontFamily: "SquidGames",
                    letterSpacing: 2,
                  )),
            ),
          ]),
          SizedBox(
            height: 3,
          ),
          Container(
            height: size.height / 3,
            width: size.width,
            child: Card(
                color: Colors.white.withOpacity(1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(12.0),
                    //   child: Text("$VehicleDetails".toUpperCase(),
                    //       style: TextStyle(
                    //         fontSize: 29,
                    //         fontWeight: FontWeight.w300,
                    //         fontFamily: "SquidGames",
                    //         letterSpacing: 2,
                    //       )),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          priceDecision(),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            // child: Text("$VehicleDetails"),
          ),
          SizedBox(
            height: 50,
          ),
          InkWell(
              child: CustomBtn(),
              onTap: () async {
                await Future.delayed(Duration(milliseconds: 300));
                switch (index) {
                  case 1:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DestinationPage(
                                  title: 'Auto Booking',
                                  page_step: 3,
                                )));
                    break;
                  case 2:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DestinationPage(
                                  title: 'Toto Booking',
                                  page_step: 3,
                                )));
                    break;
                  case 3:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DestinationPage(
                                  title: 'Pickup Booking',
                                  page_step: 3,
                                )));
                    break;

                  default:
                }
              }),
        ],
      ),
    ));
  }

  ListView listViewBuilder(List list) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: list.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Text(list[index],
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w400));
        });
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

  Widget ImageContainer(String path) => ClipRRect(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(380)),
        child: Container(
            height: Get.size.height / 2.7,
            width: Get.size.width / 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Colors.yellow,
                  // Colors.orangeAccent,
                  // Colors.yellow.shade300,
                  Color(0xFF89216B),
                  Color(0xFFCE546D)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            // decoration: BoxDecoration(
            //     // gradient: LinearGradient(
            //     //   colors: [Color(0x89216B), Color(0xCE546D)],
            //     //   begin: Alignment.topLeft,
            //     //   end: Alignment.bottomRight,
            //     // ),
            //     ),
            child: Image.asset("$path")),
      );
  List fare = ["null"];
  Widget priceDecision() {
    if (VehicleDetails == "Auto") {
      return listViewBuilder(AutoPrice);
    } else if (VehicleDetails == "Toto") {
      return listViewBuilder(TotoPrice);
    } else if (VehicleDetails == "Pickup") {
      return listViewBuilder(PickUpPrice);
    }
    return Text("No data");
  }

  List AutoPrice = [
    "1-10 KM = \u{20B9} 250",
    "1-20 KM = \u{20B9} 300",
    "1-30 KM = \u{20B9} 350",
    "1-40 KM = \u{20B9} 400",
  ];
  List TotoPrice = [
    "1-10 KM = \u{20B9} 80",
    "1-20 KM = \u{20B9} 120",
    "1-30 KM = \u{20B9} 180",
    "1-40 KM = \u{20B9} 200",
  ];
  List PickUpPrice = [
    "1-10 KM = \u{20B9} 300",
    "1-20 KM = \u{20B9} 400",
    "1-30 KM = \u{20B9} 400",
    "1-50 KM = \u{20B9} 450",
    "1-100 KM = \u{20B9} 600",
    "1-150 KM = \u{20B9} 700",
    "1-200 KM = \u{20B9} 800",
    "1-250 KM = \u{20B9} 1000",
  ];
}
