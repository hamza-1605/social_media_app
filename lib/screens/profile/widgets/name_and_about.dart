import 'package:flutter/material.dart';

class NameAndAbout extends StatelessWidget {
  const NameAndAbout({super.key, required this.name, required this.bio});
  final String name;
  final String? bio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8),
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
          
          bio != null ? 
          Text( 
            bio! ,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          )
          : SizedBox.shrink(),
        ],
      ),
    );
  }
}