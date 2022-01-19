import 'package:flutter/material.dart';

class Roundedbutton extends StatelessWidget {
  Roundedbutton(
      {required this.title, required this.color, required this.onPress});

  late final Color color;
  late final String title;
  late final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPress,
          minWidth: 200.0,
          height: 43.0,
          child: Text(
            title,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700,color: Colors.white),
          ),
        ),
      ),
    );
  }
}