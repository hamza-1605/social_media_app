import 'package:flutter/material.dart';

class IconAndNumbers extends StatelessWidget {
  const IconAndNumbers({super.key, required this.amount, required this.icon});
  final String amount;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        Icon( icon ),
        Text( amount , style: TextStyle(fontWeight: FontWeight.w600) ),
      ],
    );
  }
}