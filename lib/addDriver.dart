import 'dart:html';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dart/firebase_dart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';
import 'package:image_whisperer/image_whisperer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddDriver extends StatefulWidget {
  @override
  _AddDriverState createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Ambulances"),
        actions: [
          Padding(
            padding: EdgeInsets.all(8),
            child: IconButton(icon: Icon(Icons.add), onPressed: () {}),
          ),
        ],
      ),
      body: DriverForm(),
    );
  }
}

class DriverForm extends StatefulWidget {
  @override
  _DriverFormState createState() => _DriverFormState();
}

class _DriverFormState extends State<DriverForm> {
  final hospitalUser = FirebaseAuth.instance.currentUser;

  final _pickedImages = [];

  File fromPicker;

  dynamic image;

  Future<void> _pickImage() async {
    fromPicker = await ImagePickerWeb.getImage(outputType: ImageType.file);

    if (fromPicker != null) {
      setState(() {
        _pickedImages.clear();
        _pickedImages.add(fromPicker);
        BlobImage blobImage =
            new BlobImage(_pickedImages[0], name: DateTime.now().toString());
        image = NetworkImage(blobImage.url);
      });
    }
  }

  final formKey = GlobalKey<FormState>();

  String name, ambulanceNo, email, typeOfAmbulance, mobileNo, password;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 100),
      child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Name of Driver",
                ),
                validator: (value) {
                  if (value.isNotEmpty) {
                    name = value;
                    return null;
                  }
                  return "Required";
                },
              ),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                width: width * .5,
                height: height * .2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      _pickImage();
                    },
                    child: DottedBorder(
                        borderType: BorderType.RRect,
                        color: Colors.blue,
                        strokeWidth: 5,
                        child: Center(
                          child: _pickedImages.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(MdiIcons.gestureTap),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Tap to Upload Image',
                                      style: GoogleFonts.workSans(
                                        fontSize: 23,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                )
                              : Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image(image: image),
                                  ),
                                ),
                        )),
                  ),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Ambulance No",
                ),
                validator: (value) {
                  if (value.isNotEmpty) {
                    ambulanceNo = value;
                    return null;
                  }
                  return "Required";
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Mobile No. of Driver",
                ),
                validator: (value) {
                  if (value.isNotEmpty) {
                    mobileNo = value;
                    return null;
                  }
                  return "Required";
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "E-mail",
                ),
                validator: (value) {
                  if (value.isNotEmpty) {
                    email = value;
                    return null;
                  }
                  return "Required";
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                ),
                validator: (value) {
                  if (value.isNotEmpty) {
                    password = value;
                    return null;
                  }
                  return "Required";
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Type of Ambulance",
                ),
                validator: (value) {
                  if (value.isNotEmpty) {
                    typeOfAmbulance = value;
                    return null;
                  }
                  return "Required";
                },
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (formKey.currentState.validate()) {
                    if (_pickedImages.isNotEmpty) {
                      // setState(() {
                      //   isLoading = true;
                      // });
                      final reader = FileReader();
                      reader.readAsDataUrl(fromPicker);
                      reader.onLoadEnd.listen((event) {
                        final dateTime = DateTime.now();
                        final namel = '$dateTime';
                        fb
                            .storage()
                            .refFromURL(
                                'gs://ambulancetracker-bea10.appspot.com')
                            .child(namel)
                            .put(fromPicker)
                            .future
                            .then((value) async {
                          final imageUrl = await value.ref.getDownloadURL();
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password)
                              .then((value) async {
                            Reference(
                                    'https://ambulancetracker-bea10.firebaseio.com')
                                .child('AdminAccess')
                                .child(hospitalUser.uid)
                                .child("ambulances")
                                .child(value.user.uid)
                                .update({
                              'email': email,
                              'name': name,
                              'phone': mobileNo,
                              "typeOfAmbulance": typeOfAmbulance,
                              'Status': 'free',
                              'approveStatus': true,
                              "ambulanceNo": ambulanceNo,
                              'updatedAt': DateTime.now().toIso8601String(),
                              'id': value.user.uid,
                              'imageUrl': imageUrl.toString()
                            }).then((value) {
                              // setState(() {
                              //   _currentIndex = 1;
                              //   setState(() {
                              //     isLoading = false;
                              //   });
                              //   Fluttertoast.showToast(
                              //       msg:
                              //           'Created successfully');
                              // });
                            });
                          });
                        });
                      });
                    } else {
                      Fluttertoast.showToast(msg: 'Please select image');
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Color(0xff1A8917)),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff1A8917)),
                      borderRadius: BorderRadius.circular(10)),
                ),
              )
            ],
          )),
    );
  }
}
