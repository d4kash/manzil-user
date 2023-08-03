// import 'dart:async';

// // import 'package:geocoding/geocoding.dart';
// import 'package:flutter/material.dart';
// // import 'package:geocoding/geocoding.dart';
// // import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';

// class LocationController extends GetxController {
//   var latitude = 'Getting Latitude..'.obs;
//   var longitude = 'Getting Longitude..'.obs;
//   var address = 'Getting Address..'.obs;
//   // late StreamSubscription<Position> streamSubscription;

//   @override
//   void onInit() async {
//     super.onInit();
   
//   }

//   @override
//   void onReady() {
//     super.onReady();
//     //   Get.defaultDialog(
//     //         title: "Requested Permission",
//     //         titleStyle: TextStyle(fontSize: 18),
//     //         content: Text("Grant Location Permission,\nwhich will help both of us, for smooth journey ",
//     //             style: TextStyle(fontSize: 15)),
//     //         onConfirm: () async {
             
//     // await getLocation();
//     //         },
//     //       );
//   }

//   @override
//   void onClose() {
//     streamSubscription.cancel();
//   }

//   getLocation() async {
//     bool serviceEnabled;

//     LocationPermission permission;
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
      
//       await Geolocator.openLocationSettings();
//       return Future.error('Location services are disabled.');
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error('Location permissions are denied');
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       // return Get.dialog(
//       //     Text("You have to allow Location Permission for Location Accuracy"));
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     streamSubscription =
//         Geolocator.getPositionStream().listen((Position position) {
//       latitude.value = 'Latitude : ${position.latitude}';
//       longitude.value = 'Longitude : ${position.longitude}';
//       getAddressFromLatLang(position);
//     });
//   }

//   Future<void> getAddressFromLatLang(Position position) async {
//     List<Placemark> placemark =
//         await placemarkFromCoordinates(position.latitude, position.longitude);
//     Placemark place = placemark[0];
//     address.value =
//         'Address : ${place.street},${place.subLocality},${place.locality},${place.postalCode},${place.subAdministrativeArea},${place.administrativeArea},${place.country}';
//   }
// }





























// //Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   //Position position = await Geolocator.getLastKnownPosition()