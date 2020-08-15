import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget AppBarMain(BuildContext context) {
  return AppBar(
    title: Text(
      'Chat App',
      style: TextStyle(color: Colors.white, fontFamily: 'Nunito'),
    ),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle CustomTextStyle() {
  return TextStyle(color: Colors.white, letterSpacing: 1.0, fontSize: 18);
}
