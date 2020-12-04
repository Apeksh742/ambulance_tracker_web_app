import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dart/firebase_dart.dart';
import 'package:flutter/material.dart';
import 'package:web_app/addDriver.dart';

import 'addDriver.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool approveStatus = false;
  getStatus() {
    final user = FirebaseAuth.instance.currentUser;

    final ref = Reference('https://ambulancetracker-bea10.firebaseio.com')
        .child('AdminAccess')
        .child(user.uid);
    ref.onValue.listen((event) {
      final snapShot = event.snapshot.val;
      if (snapShot != null) {
        approveStatus = snapShot['AproveStatus'];
        setState(() {
          print(approveStatus);
        });
      }
    });
  }

  @override
  void initState() {
    getStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !approveStatus
        ? Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Card(
                    elevation: 3,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .3,
                          height: MediaQuery.of(context).size.height * .1,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10))),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * .4,
                          width: MediaQuery.of(context).size.width * .3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child:
                                    Text('Please wait till host verifies you')),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('All Ambulances'),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: InkWell(
                    child: Icon(Icons.add),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => AddDriver()));
                    },
                  ),
                )
              ],
            ),
            body: Center(
              child: Text('welcome to ice'),
            ),
          );
  }
}
