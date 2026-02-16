import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
                  ),

                  // Submit button
                  SizedBox(
                    width: double.maxFinite,
                    child: FilledButton(
                      onPressed: () async {
                        bool submitSuccess = Validators.submit(
                          context: context,
                          formKey: formKey,
                          controllers: [
                            emailController,
                            passwordController,
                          ]
                        );
                        
                        if(submitSuccess){
                          Navigator.pushReplacementNamed(context, '/start', arguments: {"name": "Postily"});
                          
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('login', true);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text("Log in", style: TextStyle(
                          fontSize: 15,
                        ),),
                      ),
                    ),
                  ),

                  // bottom
                  ClickableRichText(
                    simpleText: "Don't have an account? ", 
                    clickableText: "Create here", 
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
}