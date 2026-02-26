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


// 'Select Image from' Dialog box
Future<Uint8List?> selectImageOptions(BuildContext context){
  return showDialog<Uint8List>(
    context: context,
    builder: (dialogContext){
      return SimpleDialog(
      contentPadding: EdgeInsetsGeometry.all(20.0),
      title: Text("Upload an Image"),
      children: [
        DialogOption(
          parentContext: dialogContext,
          icondata: Icons.photo_outlined,
          text: "Choose from Gallery",
          onPress: () async{
            Uint8List? imageFile = await pickImage( ImageSource.gallery );

            if (!dialogContext.mounted) return;
            Navigator.pop(dialogContext, imageFile);
          },
        ),

        DialogOption(
          parentContext: dialogContext,
          icondata: Icons.camera_alt_outlined,
          text: "Take Picture",
          onPress: () async{
            Uint8List? imageFile = await pickImage( ImageSource.camera );

            if(!dialogContext.mounted) return;
            Navigator.pop(dialogContext, imageFile);            
          },
        ),

        DialogOption(
          parentContext: dialogContext,
          icondata: Icons.close,
          text: "Cancel",
          onPress: (){
            Navigator.pop(dialogContext); 
          },
        ),
      ],
    );
    },
  );
}




class DialogOption extends StatelessWidget {
  const DialogOption({
    super.key, required this.parentContext, 
    required this.text, required this.onPress,
    required this.icondata, 
  });
  final BuildContext parentContext;
  final String text;
  final IconData icondata;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          Icon(icondata),
          Text(text),
        ],
      ),
    );
  }
}


// for Text-based fonts
double getFontSize(String text) {
  final length = text.length;

  if (length < 40) return 32;
  if (length < 80) return 26;
  if (length < 150) return 22;
  if (length < 250) return 18;
  return 16;
}