import 'package:Manzil/screens/vehicles/ontroller/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:Manzil/Network/connectivity_provider.dart';
import 'package:Manzil/Network/no_internet.dart';
import 'package:Manzil/helper/constants.dart';
import 'package:Manzil/screens/vehicles/vehicleSelection.dart';

class BookStatus extends StatefulWidget {
  BookStatus({
    Key? key,
  }) : super(key: key);

  @override
  State<BookStatus> createState() => _BookStatusState();
}

class _BookStatusState extends State<BookStatus> {
  final Future documentStream =
      FirebaseFirestore.instance.collection('$DBUSER').doc('$UID').get();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    c = Get.put(Controller());
  }

  late Controller c;

  @override
  void dispose() {
    super.dispose();
    c.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => VehicleSelection()));
          },
        ),
        title: Text("History".toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
              fontFamily: "SquidGames",
              letterSpacing: 3,
            )),
      ),
      // body: fetchData(),
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
                  : fetchData()
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

  StreamBuilder<DocumentSnapshot<Object?>> fetchData() {
    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection("$DBUSER").doc('$UID').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            // print("${widget.Name}${widget.Date}${widget.time}");
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.active) {
            // get course document
            var courseDocument = snapshot.data!.data() as Map<String, dynamic>;
            if (courseDocument != null) {
              // get sections from the document
              var sections = courseDocument['ride'];

              // build list using names from sections
              return ListView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: sections != null ? sections.length : 0,
                  itemBuilder: (_, int index) {
                    // print(sections[index]['Date']);

                    if (sections[index]['status'] == "BOOKED") {
                      return ListTile(
                          title: Card(
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white)),
                        color: Colors.orangeAccent.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Vehicle Type:  ${sections[index]['vehicleType']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Booking Date: ${sections[index]['Date']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Booking Time: ${sections[index]['Time']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "PickUp Home: ${sections[index]['pickup']['pickup Home']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Dest Home: ${sections[index]['dest']['Dest Home']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Payment Method: ${sections[index]['payment_method']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Status: ${sections[index]['status']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ));
                    }
                    return Center(
                      child: Container(),
                    );
                  });
            } else {
              return Center(
                child: Container(
                  height: 120,
                  width: 200,
                  child: Card(
                    color: Colors.deepOrange.shade100,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No booking yet!",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Give us a chance",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          } else {
            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          }
        });
  }
}
