import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dart/firebase_dart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:web_app/addDriver.dart';
import 'package:web_app/models/driver.dart';
import 'package:web_app/screens/alertScreen.dart';

import 'addDriver.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

List<Driver> drivers = [];

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

  getUsers() {
    final user = FirebaseAuth.instance.currentUser;
    final ref = Reference('https://ambulancetracker-bea10.firebaseio.com')
        .child('AdminAccess')
        .child(user.uid)
        .child('ambulances');
    ref.onValue.listen((event) {
      final snapShot = event.snapshot.val as Map;
      if (snapShot != null) {
        drivers = [];
        snapShot.forEach((key, value) {
          drivers.add(Driver(
              id: key,
              ambulanceNo: value['ambulanceNo'],
              approvalStat: value['approveStatus'],
              email: value['email'],
              imageUrl: value['imageUrl'],
              name: value['name'],
              status: value['Status'],
              type: value['typeOfAmbulance']));
        });

        setState(() {});
      }
    });
  }

  showPopup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AlertScreen()));
  }

  @override
  void initState() {
    getStatus();
    getUsers();
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
                    child: Icon(Icons.add_alert),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AlertScreen(
                                drivers: drivers,
                              )));
                    },
                  ),
                ),
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
            body: Card(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    child: DataTable(
                      horizontalMargin: 0,
                      // horizontalMargin: 5,
                      columnSpacing: 0,
                      showBottomBorder: true,
                      columns: [
                        DataColumn(
                          label: Container(
                              width: MediaQuery.of(context).size.width * .2,
                              height: 100,
                              decoration:
                                  BoxDecoration(color: HexColor('afeeee')),
                              child: Center(
                                  child: Text('Id',
                                      style: GoogleFonts.workSans(
                                          fontWeight: FontWeight.bold)))),
                        ),
                        DataColumn(
                          label: Container(
                              width: MediaQuery.of(context).size.width * .2,
                              height: 100,
                              decoration:
                                  BoxDecoration(color: HexColor('afeeee')),
                              child: Center(
                                  child: Text('Image',
                                      style: GoogleFonts.workSans(
                                          fontWeight: FontWeight.bold)))),
                        ),
                        DataColumn(
                          label: Container(
                              width: MediaQuery.of(context).size.width * .2,
                              height: 100,
                              decoration:
                                  BoxDecoration(color: HexColor('afeeee')),
                              child: Center(
                                  child: Text('Status',
                                      style: GoogleFonts.workSans(
                                          fontWeight: FontWeight.bold)))),
                        ),
                        DataColumn(
                          label: Container(
                              width: MediaQuery.of(context).size.width * .2,
                              height: 100,
                              decoration:
                                  BoxDecoration(color: HexColor('afeeee')),
                              child: Center(
                                  child: Text('Email',
                                      style: GoogleFonts.workSans(
                                          fontWeight: FontWeight.bold)))),
                        ),
                        DataColumn(
                          label: Container(
                              width: MediaQuery.of(context).size.width * .2,
                              height: 100,
                              decoration:
                                  BoxDecoration(color: HexColor('afeeee')),
                              child: Center(
                                  child: Text('Type',
                                      style: GoogleFonts.workSans(
                                          fontWeight: FontWeight.bold)))),
                        ),
                      ],
                      rows: drivers.map((e) {
                        return DataRow(cells: [
                          DataCell(Center(child: Text(e.name))),
                          DataCell(Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Container(
                                  height: 100,
                                  width: 100,
                                  child: Image.network(e.imageUrl)),
                            ),
                          )),
                          DataCell(
                            Center(child: Text(e.status.toString())),
                          ),
                          DataCell(Center(child: Text(e.email.toString()))),
                          DataCell(Center(child: Text(e.type.toString())))
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
