import 'package:Manzil/helper/constants.dart';
import 'package:Manzil/webview/webview.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LocationPermissionScreen extends StatelessWidget {
  final VoidCallback onPressed;
  const LocationPermissionScreen({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.help),
                onPressed: () => Get.to(() => CustomWebView()),
              )),
        ),
        Icon(
          FontAwesomeIcons.locationDot,
          color: Colors.deepOrange,
          size: 80,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Use your location",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            'Sarthi Booking collects location data when in use and also \“when the app is closed\” to 1. enable doorstep delivery of you, & 2.exact roadmap of route in background only when vehicle is booked, and save time',
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: Constants.height / 45),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Icon(
          FontAwesomeIcons.mapLocationDot,
          size: 80,
          color: Colors.deepOrange,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'No Thanks',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Constants.height / 45),
                  )),
              TextButton(
                  onPressed: onPressed,
                  child: Text(
                    'Turn on',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Constants.height / 45),
                  )),
            ],
          ),
        )
      ],
    );
  }
}
