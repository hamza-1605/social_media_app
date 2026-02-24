import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

// Custom Snackbar
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


// Image picking function, returning in Uint8List form
// ignore: strict_top_level_inference
Future<Uint8List?> pickImage(ImageSource source) async{
  final ImagePicker imagePicker = ImagePicker();

  XFile? imageFile = await imagePicker.pickImage(source: source);
  if(imageFile != null){
    return await imageFile.readAsBytes();
  } 
  else{
    print("No pic selected");
    return null;
  }
}