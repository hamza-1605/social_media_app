import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ClickableRichText extends StatelessWidget {
  const ClickableRichText({super.key, required this.simpleText, required this.clickableText, required this.pathName});
  final String simpleText;
  final String clickableText;
  final String pathName;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 14, 
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface
        ),
        text: simpleText,
        children: [
          TextSpan(
            text: clickableText,
            style: TextStyle( fontSize: 14, fontWeight: FontWeight.w700, color: Colors.lightBlue),
            recognizer: TapGestureRecognizer()..onTap = (){
              Navigator.pushNamed(context, '/$pathName');
            }
          ),
        ],
      ),
    );
  }
}