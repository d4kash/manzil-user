import 'package:Manzil/Network/connectivity_provider.dart';
import 'package:Manzil/Network/no_internet.dart';
import 'package:Manzil/helper/constants.dart';
import 'package:Manzil/screens/vehicles/ontroller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../destination.dart';
import '../carSelect.dart';

class CarDetails extends StatelessWidget {
  const CarDetails({
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
    Controller c = Controller();
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
                  : SingleChildScrollView(child: Body(context, c))
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

  Widget Body(BuildContext context, Controller c) {
    return Column(
      children: [
        Stack(alignment: Alignment.bottomLeft, children: [
          Card(child: ImageContainer("$image")),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text("$VehicleDetails".toUpperCase(),
                style: TextStyle(
                  fontSize: 35,
                  color: Color(0xFFCE546D),
                  fontWeight: FontWeight.w300,
                  fontFamily: "SquidGames",
                  letterSpacing: 2,
                )),
          ),
        ]),
        // SizedBox(
        //   height: 0,
        // ),
        Container(
          height: Constant.height / 2.0,
          width: Constant.width,
          child: Card(
              color: Colors.white.withOpacity(1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(
                            "1-100 KM = \u{20B9} 800\n\n1-150 KM = \u{20B9} 1000\n\n1-200 KM = \u{20B9} 1500\n\n1-250 KM = \u{20B9} 1800\n\n1-300 KM = \u{20B9} 2000\n\n1-350 KM = \u{20B9} 2200\n\n1-400 KM = \u{20B9} 2500\n",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("+ Fuel + Toll Tax",
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w800)),
                  ),
                ],
              )),
        ),

        SizedBox(
          height: 30,
        ),
        InkWell(
            child: CustomBtn(),
            onTap: () async {
              c.isClicked.value = true;
              await Future.delayed(Duration(milliseconds: 500));
              c.isClicked.value = false;
              switch (index) {
                case 0:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DestinationPage(
                                title: 'Scorpio Booking',
                                page_step: 3,
                              )));
                  break;
                case 1:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DestinationPage(
                                title: 'Verna Booking',
                                page_step: 3,
                              )));
                  break;
                case 2:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DestinationPage(
                                title: 'Dzire Booking',
                                page_step: 3,
                              )));
                  break;
                case 3:
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DestinationPage(
                                title: 'Bolero Booking',
                                page_step: 3,
                              )));
                  break;
                default:
              }
            }),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget CustomBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
            height: 50,
            width: Constant.width,
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
}
