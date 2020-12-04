import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_app/register.dart';
import 'auth_stream.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
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
                  obscureText: true,
                  controller: passController,
                  decoration: InputDecoration(hintText: 'Password'),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => RegisterScreen()));
                    },
                    child: Text('Register')),
                FlatButton(
                    onPressed: () {
                      // print(emailController.text);
                      try {
                        AuthService().signinWithEmail(
                            emailController.text, passController.text);
                      } catch (e) {
                        Fluttertoast.showToast(msg: 'Something went wrong');
                      }
                    },
                    child: Text('Sign in')),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
