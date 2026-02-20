import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/core/resources/storage_methods.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

class AuthMethods {
  final FirebaseAuth fireAuth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<String> registerUser({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    Uint8List? file,
  }) async{
    try {
      String message = "Some error occured!";
      
      if (firstname.isNotEmpty || lastname.isNotEmpty || email.isNotEmpty) {
        UserCredential credentials = await fireAuth.createUserWithEmailAndPassword(
          email: email, 
          password: password
        );
        
        String? photoUrl;
        if( file != null ){
          photoUrl = await StorageMethods().uploadImageToCloudinary('profilePics', file, false);
        }

        await fireStore.collection('users')
          .doc( credentials.user!.uid )
          .set({
            "userid" : credentials.user!.uid,
            "firstname" : firstname,
            "lastname" : lastname,
            "email" : email,
            "profilePic": photoUrl,
            "followers" : [],
            "following" : [],
        });

        message = "Registration Successful!";
      }
      return message;
    } on FirebaseAuthException catch (e) {
      print('-------------------------');
      print(e);
      print('-------------------------');

      String message = e.code ;  
      if(e.code == "email-already-in-use"){
        message = "This email is already in use.";
      } 

      return message;
    }
  }


}