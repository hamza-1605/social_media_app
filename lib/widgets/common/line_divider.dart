import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';

class LineDivider extends StatelessWidget {
  const LineDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.middlewareGrey, 
      thickness: 0.75,
      radius: BorderRadius.circular(10.0),
    );
  }
}