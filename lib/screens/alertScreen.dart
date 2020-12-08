import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dart/firebase_dart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:web_app/models/driver.dart';
import 'package:web_app/models/user.dart';

class AlertScreen extends StatefulWidget {
  final List<Driver> drivers;
  AlertScreen({this.drivers});
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  List<Users> users = [];
  String uid;
  getAlertData() {
    final user = FirebaseAuth.instance.currentUser;
    uid = user.uid;
    final ref = Reference('https://ambulancetracker-bea10.firebaseio.com/')
        .child('AdminAccess')
        .child(user.uid)
        .child('Requests')
        .onValue;
    ref.listen((event) {
      final snapShot = event.snapshot.val as Map;
      if (snapShot != null) {
        print(snapShot);
        users = [];
        snapShot.forEach((key, value) {
          users.add(Users(
              id: value['id'],
              lat: value['lat'],
              long: value['long'],
              phone: value['Phone no'],
              status: value['Status']));
        });
        setState(() {});
      }
    });
  }

  List<Driver> drivers = [];
  @override
  void initState() {
    getAlertData();
    super.initState();
  }

  alert(Users users) {
    showDialog(
        context: context,
        child: AlertDialog(
          content: Card(
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
                                child: Text('Name',
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
                                child: Text('Type',
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
                                child: Text('Action',
                                    style: GoogleFonts.workSans(
                                        fontWeight: FontWeight.bold)))),
                      ),
                    ],
                    rows: widget.drivers.map((e) {
                      return DataRow(cells: [
                        DataCell(Center(child: Text(e.name))),
                        DataCell(
                          Center(child: Text(e.status.toString())),
                        ),
                        DataCell(Center(child: Text(e.type.toString()))),
                        DataCell(Center(
                            child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.red,
                                onPressed: () {
                                  Reference(
                                          'https://ambulancetracker-bea10.firebaseio.com/')
                                      .child('AdminAccess')
                                      .child(uid)
                                      .child('ambulances')
                                      .child(e.id)
                                      .child('req')
                                      .child(users.id)
                                      .update({
                                    'Phone': users.phone,
                                    'lat': users.lat,
                                    'long': users.long
                                  });
                                  Reference(
                                          'https://ambulancetracker-bea10.firebaseio.com/')
                                      .child('AdminAccess')
                                      .child(uid)
                                      .child('Requests')
                                      .child(users.id)
                                      .update({'Status': 'Accepted'});
                                },
                                child: Text('Assign',
                                    style: GoogleFonts.workSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)))))
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Alerts'),
      ),
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) => Card(
                child: ListTile(
                  subtitle: Text(
                    'Phone no : ${users[index].phone}',
                  ),
                  title: Text("Status " + users[index].status),
                  leading: Text(
                    'ID -  ' + users[index].id,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Container(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        alert(users[index]);
                      },
                      child: Text(
                        'Assign',
                        style: GoogleFonts.workSans(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.red,
                    ),
                  ),
                ),
              )),
    );
  }
}
