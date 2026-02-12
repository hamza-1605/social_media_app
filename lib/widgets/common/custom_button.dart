import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.btnName});
  final String btnName;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FilledButton(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(10.0)),
            side: BorderSide(color: AppColors.middlewareGrey, width: 0.5)
          ),
        ),
        
        onPressed: (){}, 
        child: Text(btnName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),)
      ),
    );
  }
}