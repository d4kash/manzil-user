import 'package:Manzil/helper/constants.dart';
import 'package:Manzil/screens/vehicles/vehicleSelection.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:Manzil/Network/connectivity_provider.dart';
import 'package:Manzil/Network/no_internet.dart';
import 'package:Manzil/helper/style.dart';

import '../destination.dart';
import 'carDetail.dart/carDetails.dart';
import 'ontroller/controller.dart';

class CarSelect extends StatelessWidget {
  CarSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Controller c = Controller();
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("CAR COLLECTION",
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
      ),
    );
  }

  final List Vehicles = [
    "assets/images/scorpio.png",
    "assets/images/verna.png",
    "assets/images/dzire.png",
    "assets/images/bolero.png"
  ];
  final List VehicleName = [
    "Scorpio",
    "Verna",
    "Dzire",
    "Bolero",
  ];
  final List VehicleRate = [
    "\u{20B9} 800-3000",
    "\u{20B9} 800-3000",
    "\u{20B9} 800-3000",
    "\u{20B9} 800-3000"
  ];
  final List VehicleDetails = [
    "scorpio is 7 seater vehicle ",
    "verna is 5 seater vehicle ",
    "Dzire is 5 seater vehicle",
    "bolero is 7 seater vehicle"
  ];
  SingleChildScrollView Body(Size size, BuildContext context, Controller c) {
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                Text("STEP 2 ",
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
                    color: Colors.black38,
                    fontSize: 15)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: Vehicles.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: Card(
                          child: Row(
                            children: [
                              OpenContainer(
                                transitionType:
                                    ContainerTransitionType.fadeThrough,
                                closedColor: Theme.of(context).cardColor,
                                closedElevation: 0.0,
                                openElevation: 4.0,
                                transitionDuration: Duration(milliseconds: 800),
                                closedBuilder: (BuildContext context,
                                    void Function() action) {
                                  return Container(
                                      height: 180,
                                      width: 180,
                                      color: Colors.grey.shade100,
                                      child:
                                          ImageContainer("${Vehicles[index]}"));
                                },
                                openBuilder: (BuildContext context,
                                        void Function({Object? returnValue})
                                            action) =>
                                    CarDetails(
                                  image: "${Vehicles[index]}",
                                  VehicleDetails: '${VehicleName[index]}',
                                  index: index,
                                  VehicleRate: '${VehicleRate[index]}',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${VehicleName[index]}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 19,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "${VehicleRate[index]}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: Constants.width/20,
                                          color: Colors.deepOrange,
                                          fontFamily: "SquidGames",
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomBtn(index, c, context),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                        // onTap: () {
                        //   switch (index) {
                        //     case 0:
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => CarDetails()));
                        //       break;
                        //     case 1:
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => DestinationPage(
                        //                     title: 'Book With VERNA',
                        //                     page_step: 3,
                        //                   )));
                        //       break;
                        //     case 2:
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => DestinationPage(
                        //                     title: 'Book with DZIRE',
                        //                     page_step: 3,
                        //                   )));
                        //       break;
                        //     case 3:
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => DestinationPage(
                        //                     title: 'Bolero',
                        //                     page_step: 3,
                        //                   )));
                        //       break;
                        //     default:
                        //   }
                        // }
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CustomBtn(int index, Controller c, BuildContext context1) {
    return InkWell(
      onTap: () async {
        c.isClicked.value = true;
        await Future.delayed(Duration(milliseconds: 500));
        c.isClicked.value = false;
        switch (index) {
          case 0:
            Get.to(() => DestinationPage(
                  title: 'Scorpio Booking',
                  page_step: 3,
                ));
            // Navigator.push(
            //     context1,
            //     MaterialPageRoute(
            //         builder: (context1) => DestinationPage(
            //               title: 'Scorpio Booking',
            //               page_step: 3,
            //             )));
            break;
          case 1:
            Get.to(() => DestinationPage(
                  title: 'Verna Booking',
                  page_step: 3,
                ));
            // Navigator.push(
            //     context1,
            //     MaterialPageRoute(
            //         builder: (context1) => DestinationPage(
            //               title: 'Verna Booking',
            //               page_step: 3,
            //             )));
            break;
          case 2:
            Get.to(() => DestinationPage(
                  title: 'Dzire Booking',
                  page_step: 3,
                ));
            // Navigator.push(
            //     context1,
            //     MaterialPageRoute(
            //         builder: (context1) => DestinationPage(
            //               title: 'Dzire Booking',
            //               page_step: 3,
            //             )));
            break;
          case 3:
            Get.to(() => DestinationPage(
                  title: 'Bolero Booking',
                  page_step: 3,
                ));
            // Navigator.push(
            //     context1,
            //     MaterialPageRoute(
            //         builder: (context1) => DestinationPage(
            //               title: 'Bolero Booking',
            //               page_step: 3,
            //             )));
            break;
          default:
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
              height: 50,
              width: Constants.width/3,
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
      ),
    );
  }

  Container ImageContainer(String path) =>
      Container(child: Image.asset("$path"));
}
