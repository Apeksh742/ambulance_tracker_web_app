import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dart/firebase_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'homePage.dart';
import 'loginScreen.dart';


class AuthService {
  checkAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Home();
          } else {
            return LoginScreen();
          }
        });
  }

  signinWithEmail(String email, String password) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
          
        })
        .catchError((e) {
      Fluttertoast.showToast(msg: 'Something Went wrong');
    });
  }

  registerWithEmail(String email, String password, String hospitalName, String hospitalAddress, String contactNo, BuildContext context,double lat,double long) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      final user = value.user.uid;
      final ref =
          Reference('https://ambulancetracker-bea10.firebaseio.com/AdminAccess/$user');
      ref.update({
        'AproveStatus': false,
        'lat':lat,
        'long':long,
        'HospialName': hospitalName,
        'HospitalAddress': hospitalAddress,
        'Contact No': contactNo,

      }).then((value) => Navigator.of(context).pop(context));
    });
  }
}
