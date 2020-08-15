import 'package:flutter/material.dart';
import 'package:my_app/views/signIn.dart';
import 'package:my_app/views/signUp.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignin = true;
  void toggleView() {
    setState(() {
      showSignin = !showSignin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignin ? SignIn(this.toggleView) : SignUp(this.toggleView);
  }
}
