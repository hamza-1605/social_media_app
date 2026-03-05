import 'package:flutter/material.dart';

class NameAndAbout extends StatelessWidget {
  const NameAndAbout({super.key, required this.email, required this.bio});
  final String email;
  final String bio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text( 
            email, 
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