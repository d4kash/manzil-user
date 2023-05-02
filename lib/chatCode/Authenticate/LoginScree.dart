import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:provider/provider.dart';
import 'package:Manzil/Network/connectivity_provider.dart';
import 'package:Manzil/Network/no_internet.dart';
import 'package:Manzil/chatCode/Screens/HomeScreen.dart';
import 'package:Manzil/screens/vehicles/vehicleSelection.dart';

import 'CreateAccount.dart';
import 'ForgotPassword.dart';
import 'Methods.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  GlobalKey<ScaffoldState>? scaffoldSate = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool _obscureText = true;
  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // body:
      body: Consumer<ConnectivityProvider>(
          builder: (consumerContext, model, child) {
        // print(context.watch<ConnectivityProvider>());

        if (model.isOnline != null) {
          return model.isOnline
              ? isLoading
                  ? Center(
                      child: Container(
                        height: size.height / 20,
                        width: size.height / 20,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : showWidget(size, context)
              : NoInternet();
        }
        ;
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }),
    );
  }

  SingleChildScrollView showWidget(Size size, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: size.height / 10,
          ),
          // Container(
          //   alignment: Alignment.centerLeft,
          //   width: size.width / 0.5,
          //   child:
          //       IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {}),
          // ),
          SizedBox(
            height: size.height / 50,
          ),
          Container(
            width: size.width / 1.1,
            child: Text(
              "Identify yourself!",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: size.width / 1.1,
            child: Text(
              "To get entry in your house!",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: size.height / 10,
          ),
          Container(
            width: size.width,
            alignment: Alignment.center,
            child: field(size, "email", Icons.account_box, _email, false),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Container(
              width: size.width,
              alignment: Alignment.center,
              child: Stack(children: [
                field(
                  size,
                  "password",
                  Icons.lock,
                  _password,
                  _obscureText,
                ),
                Positioned(
                  top: 2,
                  right: 10,
                  child: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      }),
                ),
              ]),
            ),
          ),
          SizedBox(
            height: size.height / 10,
          ),
          customButton(size),
          Container(
              height: size.height / 14,
              width: size.width / 1.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white38),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => Get.to(ForgotPassword(),
                        transition: Transition.cupertino),
                    child: Text(
                      " Forgot Password",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )),
          SizedBox(
            height: size.height / 40,
          ),
          Container(
              height: size.height / 14,
              width: size.width / 1.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white38),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have account? ",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.to(CreateAccount(),
                        transition: Transition.cupertino),
                    child: Text(
                      " SIGNUP",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          logIn(_email.text, _password.text).then((user) {
            if (user != null) {
              print("Login Sucessfull");
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("welcome to your house!"),
              ));
              setState(() {
                isLoading = false;
              });
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => VehicleSelection()));
            } else {
              print("Login Failed");
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("you are not identified by our member!"),
              ));
              setState(() {
                isLoading = false;
              });
            }
          });
        } else {
          print("Please fill form correctly");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please Fill all feilds correctly!"),
          ));
        }
      },
      child: Container(
          height: size.height / 14,
          width: size.width / 1.2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.deepOrange),
          alignment: Alignment.center,
          child: Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }

  Widget field(Size size, String hintText, IconData icon,
      TextEditingController cont, bool obsc) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
        controller: cont,
        obscureText: obsc,
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
