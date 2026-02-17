import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/utils/validators.dart';
import 'package:social_media_app/screens/authentication/widgets/custom_text_box.dart';
import 'package:social_media_app/screens/authentication/widgets/heading_text.dart';
import 'package:social_media_app/widgets/common/appname_text.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

final formkey = GlobalKey<FormState>();

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController mailController = TextEditingController();
  FocusNode mailNode = FocusNode();
  bool isloading = false;

  @override
  void dispose() {
    mailController.dispose();
    mailNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formkey,
            child: Column(
              spacing: 20.0,
              children: [
                AppnameText(),
                SizedBox(height: 50.0),
                HeadingText(
                  heading: "RESET PASSWORD", 
                  subheading: "Enter your email below and we will send you a reset password link."
                ),
            
                SizedBox(height: 10.0),
        
                CustomTextBox(
                  controller: mailController, 
                  label: "Enter your email", 
                  node: mailNode, 
                  submit: () => FocusScope.of(context).unfocus(),
                  validator: (email) => Validators.emailValidator(email),
                ),
            
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: forgotPassword,
                    child: isloading
                      ? SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator( color: Colors.white ),
                      ) 
                      : Text("Send Link"),
                  ),
                ),
        
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 5.0,
                    children: [
                      Icon(Icons.arrow_circle_left_outlined, color: AppColors.logoColor,),
                      Text(
                        "Go back to the Login page", 
                        style: TextStyle(
                          color: AppColors.logoColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Future forgotPassword() async{
    try {
      if( !formkey.currentState!.validate() ) return;

      setState(() {
        isloading = true;
      });

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: mailController.text.trim()
      );

      if(!mounted) return;
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title: HeadingText(
              heading: "Password Reset Link Sent!", 
              subheading: "A link to reset the password has been successfully. Please check your email.\n\n(It may be in the Spam folder)"
            )
          );
        },
      );
    } 
    on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
          behavior: SnackBarBehavior.floating,
        )
      );
    } 
    finally{
      setState(() {
        isloading = false;
      });
    }
  }
}