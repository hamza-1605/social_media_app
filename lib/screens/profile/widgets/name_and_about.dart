import 'package:flutter/material.dart';

class NameAndAbout extends StatelessWidget {
  const NameAndAbout({super.key, required this.name, required this.bio});
  final String name;
  final String bio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text( 
            name, 
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700
            ),
          ),
          Text( 
            bio,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }
}