import 'package:flutter/material.dart';

import 'auth_stream.dart';


class RegisterScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
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
                  print(emailController.text);
                  AuthService().registerWithEmail(
                      emailController.text, passController.text, context);
                },
                child: Text('Sign in'))
          ],
        ),
      ),
    ));
  }
}
