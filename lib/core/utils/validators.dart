import 'package:flutter/material.dart';

class Validators {
  static String? emailValidator(String? email) {
    if(email == null || email.isEmpty){
      return "Email can't be empty.";
    }
    else if( !email.contains('@') ){
      return "Please enter a valid Email.";
    }
    else{
      return null;
    }
  }
  

  static String? passwordValidator(String? password) {
    if(password == null || password.isEmpty){
      return "Password can't be empty.";
    }
    else if(password.length < 6){
      return "Password must be 6 or more characters long.";
    }
    else{
      return null;
    }
  }
  
  static String? loginPasswordValidator(String? password) {
    if(password == null || password.isEmpty){
      return "Password can't be empty.";
    }
    else{
      return null;
    }
  }

  static String? rePasswordValidator(String? password, String? rePassword) {
    if(rePassword == null || rePassword.isEmpty){
      return "Password can't be empty.";
    }
    else if(rePassword != password){
      return "Passwords do not match.";
    }
    else{
      return null;
    }
  }


  static String? nameValidator(String? name){
    if( name == null || name.isEmpty ){
      return "Name can't be empty";
    }
    else{
      return null;
    }
  }


  static bool submit({
    required BuildContext context, 
    required GlobalKey<FormState> formKey,
  }){
    final form = formKey.currentState! ;
    if( !form.validate() )  return false;

    form.save();
    FocusScope.of(context).unfocus();
    
    return true;
  }

  static void clearControllers({
    required List<TextEditingController> controllers,
    required GlobalKey<FormState> formKey,
  }){
    final form = formKey.currentState!;
    
    for( final controller in controllers ) {
      controller.clear();
    }
    form.reset();
  }
}