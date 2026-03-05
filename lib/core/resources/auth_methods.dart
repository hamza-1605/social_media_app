import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/core/resources/storage_methods.dart';
import 'package:social_media_app/models/user.dart' as model;
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

class AuthMethods {
  final FirebaseAuth fireAuth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<model.User?> getUserDetails() async{
    User? currentUser = fireAuth.currentUser ;
    if(currentUser == null) return null;
    
    DocumentSnapshot snap = await fireStore.collection("users")
                                           .doc( currentUser.uid )
                                           .get();
    return model.User.fromSnapToUser(snap);
  }


  Future<String> registerUser({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    Uint8List? file,
  }) async{
    try {
      String message = "Some error occured!";
      
      if (firstname.isNotEmpty && lastname.isNotEmpty && email.isNotEmpty) {
        UserCredential credentials = await fireAuth.createUserWithEmailAndPassword(
          email: email, 
          password: password
        );
        
        String userid = credentials.user!.uid;
        String? photoUrl;
        if( file != null ){
          photoUrl = await StorageMethods()
                          .uploadImageToCloudinary(image: file, isPost: false);
        }
        

        model.User newUser = model.User(
          firstname: firstname, 
          lastname: lastname, 
          email: email, 
          userid: userid, 
          followers: [], 
          following: [],
          photoUrl: photoUrl,
          bio: "",
          postsCount: 0,
        );        

        await fireStore.collection('users')
          .doc( credentials.user!.uid )
          .set( newUser.toJson() );

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

  
  Future<String> loginCredentials({
    required String email,
    required String password,
  }) async {
    String message = "Login Failed";
    try{
      if(email.trim().isNotEmpty && password.trim().isNotEmpty){

        await fireAuth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
        message = "Login Successful!";
      }
      return message;
    } on FirebaseAuthException catch (e) {
      print('-------------------------');
      print(e);
      print('-------------------------');

      if(e.code == "invalid-credential"){
        message = "Check your credentials again.";
      }
      return message ;
    }
  }

}