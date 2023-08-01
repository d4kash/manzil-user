import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class Constants {
  static double height = Get.size.height;
  static double width = Get.size.width;
}

const String RIDECOUNT = "0";
const String DBUSER = "user";
const String DBUSER_PROFILE = "users";
String UID = "${FirebaseAuth.instance.currentUser!.uid}";
const List TIME_SLOT = [
  "07:00 AM - 07:30 AM",
  "07:31 AM - 07:59 AM",
  "08:00 AM - 08:30 AM",
  "08:31 AM - 08:59 AM",
  "09:00 AM - 09:30 AM",
  "09:31 AM - 09:59 AM",
  "10:00 AM - 10:30 AM",
  "10:31 AM - 10:59 AM",
  "11:00 AM - 11:30 AM",
  "11:31 AM - 11:59 AM",
  "12:00 PM - 12:30 PM",
  "12:31 PM - 12:59 PM",
  "01:00 PM - 01:30 PM",
  "01:31 PM - 01:59 PM",
  "02:00 PM - 02:30 PM",
  "02:31 PM - 02:59 PM",
  "03:00 PM - 03:30 PM",
  "03:31 PM - 03:59 PM",
  "04:00 PM - 04:30 PM",
  "04:31 PM - 04:59 PM",
  "05:00 PM - 05:30 PM",
  "05:31 PM - 05:59 PM",
  "06:00 PM - 06:30 PM",
  "06:31 PM - 06:59 PM",
  "07:00 PM - 07:30 PM",
  "07:31 PM - 07:59 PM",
  "08:00 PM - 08:30 PM",
  "08:31 PM - 08:59 PM",
  "09:00 PM - 09:30 PM",
  "09:31 PM - 09:59 PM",
  "10:00 PM - 10:30 PM",
  "10:31 PM - 10:59 PM",
  "11:00 PM - 11:30 PM",
  "11:31 PM - 11:59 PM",
  "12:00 AM - 12:30 AM",
  "12:31 AM - 12:59 AM",
  "01:00 AM - 01:30 AM",
  "01:31 AM - 01:59 AM",
  "02:00 AM - 02:30 AM",
  "02:31 AM - 02:59 AM",
  "03:00 AM - 03:30 AM",
  "03:31 AM - 03:59 AM",
  "04:00 AM - 04:30 AM",
  "04:31 AM - 04:59 AM",
  "05:00 AM - 05:30 AM",
  "05:31 AM - 05:59 AM",
  "06:00 AM - 06:30 AM",
  "06:31 AM - 06:59 AM",
];
const List Distance_Slot = [
  "1 - 5 KM",
  "1 - 10 KM",
  "1 - 20 KM",
  "1 - 50 KM",
  "1 - 100 KM",
  "1 - 150 KM",
  "1 - 200 KM",
  "1 - 250 KM",
  "1 - 300 KM",
  '1 - 350 KM',
  '1 - 400 KM',
];
