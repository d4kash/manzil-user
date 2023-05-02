import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Manzil/chatCode/Authenticate/Methods.dart';
import 'package:Manzil/chatCode/group_chats/group_chat_screen.dart';
import 'package:Manzil/screens/vehicles/vehicleSelection.dart';
import 'package:Manzil/widget/ExitDialog.dart';

import 'ChatRoom.dart';

class ChatHomeScreen extends StatefulWidget {
  @override
  _ChatHomeScreenState createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen>
    with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map Email = {
    "Raunak": "raunakraj3888@gmail.com",
    "Daksh": "daksh1@gmail.com"
  };

  var emailtochat;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: emailtochat)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat with us"),
          leading: InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => VehicleSelection()));
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black54,
            ),
          ),
          // actions: [
          //   IconButton(icon: Icon(Icons.logout), onPressed: () => logOut(context))
          // ],
        ),
        body: isLoading
            ? Center(
                child: Container(
                  height: size.height / 20,
                  width: size.height / 20,
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                children: [
                  // SizedBox(
                  //   height: size.height / 20,
                  // ),
                  // Container(
                  //   height: size.height / 14,
                  //   width: size.width,
                  //   alignment: Alignment.center,
                  //   child: Container(
                  //     height: size.height / 14,
                  //     width: size.width / 1.15,
                  //     child: TextField(
                  //       controller: _search,
                  //       decoration: InputDecoration(
                  //         hintText: "Search",
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: size.height / 50,
                  // ),
                  // ElevatedButton(
                  //   onPressed: onSearch,
                  //   child: Text("Search"),
                  // ),
                  // // SizedBox(
                  // //   height: size.height / 30,
                  // // ),
                  // SizedBox(
                  //   height: size.height / 50,
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Select any email to chat",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ListMethod(),
                      ListTile()
                    ],
                  ),
                  userMap != null
                      ? ListTile(
                          onTap: () {
                            String roomId = chatRoomId(
                                _auth.currentUser!.displayName!,
                                userMap!['name']);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ChatRoom(
                                  chatRoomId: roomId,
                                  userMap: userMap!,
                                ),
                              ),
                            );
                          },
                          leading: Icon(Icons.account_box, color: Colors.black),
                          title: Text(
                            userMap!['name'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(userMap!['email']),
                          trailing: Icon(Icons.chat, color: Colors.black),
                        )
                      : Container(),
                ],
              ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.group),
        //   onPressed: () => Navigator.of(context).push(
        //     MaterialPageRoute(
        //       builder: (_) => GroupChatHomeScreen(),
        //     ),
        //   ),
        // ),
      ),
    );
  }

  Center ListMethod() {
    return Center(
      child: Container(
        // height: 120,
        // width: 230,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: Email.length,
          itemBuilder: (context, index) {
            String key = Email.keys.elementAt(index);
            return InkWell(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            Email.keys.elementAt(index),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Icon(Icons.arrow_forward_ios_outlined,
                              color: Colors.black54),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
              onTap: () {
                switch (index) {
                  case 0:
                    setState(() {
                      emailtochat = Email[key];
                    });
                    print(Email[key]);
                    print(Email.keys.elementAt(index));
                    onSearch();
                    userMap != null
                        ? ListTile(
                            onTap: () {
                              String roomId = chatRoomId(
                                  _auth.currentUser!.displayName!,
                                  userMap!['name']);

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ChatRoom(
                                    chatRoomId: roomId,
                                    userMap: userMap!,
                                  ),
                                ),
                              );
                            },
                            leading:
                                Icon(Icons.account_box, color: Colors.black),
                            title: Text(
                              userMap!['name'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(userMap!['email']),
                            trailing: Icon(Icons.chat, color: Colors.black),
                          )
                        : Container();
                    String roomId = chatRoomId(_auth.currentUser!.displayName!,
                        userMap![Email.keys.elementAt(index)]);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatRoom(
                          chatRoomId: roomId,
                          userMap: userMap!,
                        ),
                      ),
                    );
                    break;
                  case 1:
                    print(Email[key]);
                    setState(() {
                      emailtochat = Email[key];
                    });
                    print(Email[key]);
                    print(Email.keys.elementAt(index));
                    onSearch();
                    userMap != null
                        ? ListTile(
                            onTap: () {
                              String roomId = chatRoomId(
                                  _auth.currentUser!.displayName!,
                                  userMap!['name']);

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ChatRoom(
                                    chatRoomId: roomId,
                                    userMap: userMap!,
                                  ),
                                ),
                              );
                            },
                            leading:
                                Icon(Icons.account_box, color: Colors.black),
                            title: Text(
                              userMap!['name'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(userMap!['email']),
                            trailing: Icon(Icons.chat, color: Colors.black),
                          )
                        : Container();
                    String roomId = chatRoomId(_auth.currentUser!.displayName!,
                        userMap![Email.keys.elementAt(index)]);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatRoom(
                          chatRoomId: roomId,
                          userMap: userMap!,
                        ),
                      ),
                    );
                    break;
                  default:
                }
              },
            );
          },
        ),
      ),
    );
  }
}
