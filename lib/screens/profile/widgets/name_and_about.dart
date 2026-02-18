import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';

class NameAndAbout extends StatelessWidget {
  const NameAndAbout({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text( email, 
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700
            ),
          ),
          Text("Flutter Intern" , 
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.middlewareGrey
            ),
          ),
          Text("Ambitious Sloth 🐨\nEmbrace the glorious mess that you are🌻~Elizabeth Gilbert",
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