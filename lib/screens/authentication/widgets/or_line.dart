import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';

class OrLine extends StatelessWidget {
  const OrLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 0.5,
            color: AppColors.middlewareGrey,
          )
        ),
        Text(" or "),
        Expanded(
          child: Divider(
            thickness: 0.5,
            color: AppColors.middlewareGrey,
          )
        ),
      ],
    );
  }
}