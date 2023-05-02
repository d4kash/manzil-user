import 'package:Manzil/screens/drawer/Status.dart';
import 'package:Manzil/screens/vehicles/vehicleSelection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'Network/connectivity_provider.dart';
import 'chatCode/Authenticate/Autheticate.dart';
import 'chatCode/Screens/HomeScreen.dart';
import 'splashScreen/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // to load onboard for the first time only

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static GlobalKey<ScaffoldState>? scaffoldSate = GlobalKey<ScaffoldState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
          child: Authenticate(),
        )
      ],
      child: GetMaterialApp(
        title: 'Manzil',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: SplashScreen(),
        routes: {
          '/Home': (context) => VehicleSelection(),
          '/ReqRide': (context) => RideHistory(),
          '/chat': (context) => ChatHomeScreen(),
        },
      ),
    );
  }
}
