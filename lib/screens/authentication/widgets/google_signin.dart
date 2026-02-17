// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/core/constants/app_colors.dart';

class GoogleSignin extends StatefulWidget {
  const GoogleSignin({super.key});

  @override
  State<GoogleSignin> createState() => _GoogleSigninState();
}

class _GoogleSigninState extends State<GoogleSignin> {
  bool isLoading = false;

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
      
      setState(() {
        isLoading = true;
      });
      return FirebaseAuth.instance.signInWithCredential( credentials );

    } catch (e) {
      print('Google sign-in error: $e');
      return null;
    } finally{
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }


  void printUserSignInStatus(BuildContext context) async{
    final userAuth = await googleSignIn();
    if(userAuth != null){
      print("User logged in as: ${userAuth.user?.displayName}");
      
      if(!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/start', arguments: {"name" : userAuth.user!.displayName });
      
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('login', true);
    } else{
      print("Sign-in interrupted!");
    }
  }



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () {
          printUserSignInStatus(context);
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
}