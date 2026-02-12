import 'package:flutter/material.dart';

class AppnameText extends StatelessWidget {
  const AppnameText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Postily", 
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: Colors.blueAccent
      ),
    );
  }
}