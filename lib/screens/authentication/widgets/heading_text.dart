import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  const HeadingText({super.key, required this.heading, required this.subheading});
  final String heading;
  final String subheading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface
          ),
          text: heading,
          children: [
            TextSpan(
              text: '\n\n$subheading',
              style: TextStyle( fontSize: 14, fontWeight: FontWeight.w500)
            ),
          ],
        ),
      ),
    );
  }
}