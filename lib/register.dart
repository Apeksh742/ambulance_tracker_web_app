import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';

import 'auth_stream.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  LocationData _locationData;
  getPermissionStatus() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }

  Location location = new Location();

  TextEditingController emailController = TextEditingController();

  TextEditingController passController = TextEditingController();
  @override
  void initState() {
    getPermissionStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
            ),
            Container(
              height: MediaQuery.of(context).size.height * .4,
              width: MediaQuery.of(context).size.width * .4,
              child: Image.asset('assets/hospital.png'),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width * .4,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                height: 20,
                width: MediaQuery.of(context).size.width * .4,
                child: TextField(
                  controller: passController,
                  decoration: InputDecoration(hintText: 'Password'),
                )),
            FlatButton(
                onPressed: () {
                  if (_locationData != null) {
                    AuthService().registerWithEmail(
                        emailController.text,
                        passController.text,
                        context,
                        _locationData.latitude,
                        _locationData.longitude);
                  } else {
                    Fluttertoast.showToast(msg: 'please allow for location');
                  }
                },
                child: Text('Sign in'))
          ],
        ),
      ),
    ));
  }
}
