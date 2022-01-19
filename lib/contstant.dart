import 'package:flutter/material.dart';

const textfiel_design = InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
        width: 12.0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(20.0),
      ),
    ),
    filled: true,
    fillColor: Colors.black26,
    hintText: 'Enter Your E-Mail',
    hintStyle: TextStyle(
      color: Colors.white70,
    ));

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  fillColor: Colors.blueGrey,
  filled: true,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

class constant{
  static String myname ="";
}
