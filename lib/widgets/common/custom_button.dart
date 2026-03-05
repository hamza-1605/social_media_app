import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.btnName, required this.onTap, this.transparent} );
  final String btnName;
  final Function onTap;
  final bool? transparent;
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FilledButton(
        style: transparent == true 
          ? FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.buttonBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(10.0)),
              side: BorderSide(color: AppColors.buttonBlue, width: 1)
            ),
          )
          : FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(10.0)),
              side: BorderSide(color: AppColors.middlewareGrey, width: 0.5)
            ),
          ),
        
        onPressed: () => onTap(), 
        child: Text(
          btnName, 
          style: TextStyle(
            fontWeight: FontWeight.w700, 
            fontSize: 15
          ),
        )
      ),
    );
  }
}