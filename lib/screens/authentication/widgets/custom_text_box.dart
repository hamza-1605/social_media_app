import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';

class CustomTextBox extends StatelessWidget {
  const CustomTextBox({
    super.key,
    required this.controller, 
    required this.label, 
    this.validator,
    this.obscureText = false,
    required this.node,
    required this.submit,
    this.suffixIcon,
    this.suffixPress,
    this.keyboardType = TextInputType.text ,
  });

  final TextEditingController controller;
  final String label;
  final FocusNode node;
  final VoidCallback submit;
  final bool obscureText;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;
  final VoidCallback? suffixPress;
  final TextInputType? keyboardType;
  

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      focusNode: node,
      keyboardType: keyboardType,
      onFieldSubmitted: (value) => submit() ,
      // onTapOutside: (event) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffixIcon != null 
          ? IconButton(
            onPressed: suffixPress, 
            icon: Icon(suffixIcon)
          )
          : null,

        border: OutlineInputBorder(
          borderSide: BorderSide( color: AppColors.middlewareGrey, width: 0.5 ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide( color: AppColors.middlewareGrey, width: 0.5 ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide( color: Colors.blueAccent, width: 0.9 ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 1)
        ),
      ),
      
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}