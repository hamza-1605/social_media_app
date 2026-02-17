import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/utils/validators.dart';
import 'package:social_media_app/screens/authentication/widgets/clickable_rich_text.dart';
import 'package:social_media_app/screens/authentication/widgets/custom_text_box.dart';
import 'package:social_media_app/screens/authentication/widgets/google_signin.dart';
import 'package:social_media_app/screens/authentication/widgets/heading_text.dart';
import 'package:social_media_app/screens/authentication/widgets/or_line.dart';
import 'package:social_media_app/widgets/common/appname_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  bool loading = false;
  bool showPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                spacing: 20.0,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: AppnameText()
                  ),

                  HeadingText(
                    heading: "LOG IN",
                    subheading: "Please sign in to continue...",
                  ),
                  
                  // Email
                  CustomTextBox(
                    controller: emailController,
                    node: emailNode,
                    label: "Email",
                    submit: () => FocusScope.of(context).requestFocus(passwordNode),
                    validator: (email) => Validators.emailValidator(email),
                  ),

                  // Password
                  CustomTextBox(
                    controller: passwordController,
                    node: passwordNode,
                    label: "Password",
                    submit: () => FocusScope.of(context).unfocus(),
                    validator: (password) => Validators.loginPasswordValidator(password),
                    obscureText: !showPassword,
                    suffixIcon: passwordVisibility( showPassword ),
                    suffixPress: () => setState(() => showPassword = !showPassword),
                  ),

                  // Reset Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: Text( 
                          "Forgot password?", 
                          style: TextStyle(
                            color: AppColors.logoColor,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Submit button
                  SizedBox(
                    width: double.maxFinite,
                    child: FilledButton(
                      onPressed: () {
                        logIn();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: loading 
                          ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                          : Text("Log in", style: TextStyle(
                            fontSize: 15,
                          ),)
                      ),
                    ),
                  ),

                  // bottom
                  ClickableRichText(
                    simpleText: "Don't have an account? ", 
                    clickableText: "Create here.", 
                    pathName: "register"
                  ),

                  OrLine(),

                  GoogleSignin(),
                ],
              ), 
            ),
          ),
        ),
      ),
    );
  }

  Future logIn() async{
    try {
      bool submitSuccess = Validators.submit(
        context: context,
        formKey: formKey,
      );
    
      if(submitSuccess){
        setState(() {
          loading = true;
        });

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(), 
          password: passwordController.text.trim(),
        );

        if(!mounted) return;
        Navigator.pushReplacementNamed(context, '/start', arguments: {"name": "Postily"});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login Successful!"),
            behavior: SnackBarBehavior.floating,
          )
        );

        Validators.clearControllers( 
          formKey: formKey,
          controllers: [
            emailController,
            passwordController,
          ]
        );
      }
    } on FirebaseAuthException catch (e) {
      print('-------------------------');
      print(e);
      print('-------------------------');

      String message = "Login failed";
      
      if(e.code == "invalid-credential"){
        message = "Invalid Credentials. Recheck your credentials.";
      } else if(e.code == "too-many-requests"){
        message = "Too many requests. Please try again later.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(15.0)),
          showCloseIcon: true,
          duration: Duration(milliseconds: 2500),
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }


  IconData passwordVisibility (bool value) => value ? Icons.visibility : Icons.visibility_off;
}