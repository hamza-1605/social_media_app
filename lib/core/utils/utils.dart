import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar( BuildContext context, String content ){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(15.0)),
      showCloseIcon: true,
      duration: Duration(milliseconds: 2000),
    ),
  );
}

// ignore: strict_top_level_inference
pickImage(ImageSource source) async{
  final ImagePicker imagePicker = ImagePicker();

  XFile? imageFile = await imagePicker.pickImage(source: source);
  if(imageFile != null){
    return await imageFile.readAsBytes();
  } 
  else{
    print("No pic selected");
  }
}