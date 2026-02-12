import 'package:flutter/material.dart';

class NumbersColumn extends StatelessWidget {
  const NumbersColumn({super.key, required this.label, required this.number});
  final String label;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text( number , style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),),
        Text( label , style: TextStyle(fontSize: 15.0) ),
      ],
    );
  }
}