// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media_app/core/constants/app_colors.dart';

class GoogleSignin extends StatefulWidget {
  const GoogleSignin({super.key});

  @override
  State<GoogleSignin> createState() => _GoogleSigninState();
}

class _GoogleSigninState extends State<GoogleSignin> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () {
          printUserStatusAndNavigate(context);
        },
        
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          side: BorderSide( color: Theme.of(context).colorScheme.onSurface, width: 0.5 ) 
        ),

        child: isLoading 
        ? SizedBox(
          height: 25,
          width: 25,
          child: Center(child: CircularProgressIndicator(color: AppColors.logoColor,))
        )
        : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10.0,
          children: [
            Image.asset("assets/images/google_logo.png" , width: 20),
            Text("Continue with Google", style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface
            ),)
          ],
        ),
      ),
    );
  }



  void printUserStatusAndNavigate(BuildContext context) async{
    final userAuth = await googleSignIn();
    if(userAuth != null){
      print("User logged in as: ${userAuth.user?.displayName}");
      
      if(!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/start');
    } else{
      print("Sign-in interrupted!");
    }
  }


  Future<UserCredential?> googleSignIn() async {
    setState(() => isLoading = true);
    
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if(googleUser == null){
        return null;            // User probably cancelled login
      }

      // getting authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication ;
      
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      // signing in with credentials
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential( credentials );
      
      // creating new user if it didn't exist in firestoew  
      await createUserInFirestore(userCredential);
      return userCredential;
    } 
    catch (e) {
      print('Google sign-in error: $e');
      return null;
    } 
    finally{
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }



  Future<void> createUserInFirestore(UserCredential userCredential) async{
    final user = userCredential.user;
    if(user == null) return;  // userCredentials were incorrect

    // seeing if user exists in firestore (for additional details)
    final userDoc = await FirebaseFirestore.instance.collection('users')
      .doc( user.uid )
      .get();

    // execute only when user does not exits in firestore
    if( !userDoc.exists ){
      String? userProfile = user.photoURL;

      await FirebaseFirestore.instance.collection('users')
        .doc( user.uid )
        .set({
          "firstname" : user.displayName?.split(" ").first ?? " ",
          "lastname" : user.displayName?.split(" ").last ?? " ",
          "email" : user.email,
          "profilePic" : userProfile,
          "userid" : user.uid,
          "followers" : [],
          "following" : []
        }); 
      print("New Google user saved to Firestore");
    } 
    else {
      print("User already exists in Firestore");
    }
  }

}