import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';

class SelectGender extends StatelessWidget {
  const SelectGender({super.key, required this.gender, required this.onGenderChange});
  final String gender;
  final ValueChanged<String> onGenderChange;
  

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20.0,
      children: [
        Text(
          "Gender: ",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ), 
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.middlewareGrey, width: 0.5),
            borderRadius: BorderRadius.circular(5.0)
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: DropdownButton(
            underline: SizedBox(),
            borderRadius: BorderRadius.circular(10.0),
            value: gender,
            barrierDismissible: true,
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.middlewareGrey),
            items: [
              DropdownMenuItem(
                value: "", 
                enabled: false,
                child: Text("--Select Gender--", style: TextStyle( color: AppColors.middlewareGrey),),
              ),
              DropdownMenuItem( value: "male", child: Text("Male"),),
              DropdownMenuItem(value: "female", child: Text("Female"),),
              DropdownMenuItem(value: "nope", child: Text("Rather not say"),),
            ], 
            onChanged: (value) {
              if( value != null ){
                onGenderChange(value);
              }
            }
          ),
        ),
      ],
    );
  }
}