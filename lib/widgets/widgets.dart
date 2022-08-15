import 'package:flutter/material.dart';

AppBar appBarMain() {
  return AppBar(
    title: const Icon(
      Icons.chat,
      color: Colors.greenAccent,
      size: 25.0,
    ),

    backgroundColor: Colors.cyan[900],
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white54),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)),
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextField() {
  return const TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle mediumTextField() {
  return const TextStyle(color: Colors.white, fontSize: 17);
}
