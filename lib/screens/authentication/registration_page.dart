  import 'dart:typed_data';

  import 'package:flutter/material.dart';
  import 'package:image_picker/image_picker.dart';

  import 'package:social_media_app/core/resources/auth_methods.dart';
  import 'package:social_media_app/core/utils/utils.dart';
  import 'package:social_media_app/core/utils/validators.dart';
  import 'package:social_media_app/screens/authentication/widgets/clickable_rich_text.dart';
  import 'package:social_media_app/screens/authentication/widgets/custom_text_box.dart';
  import 'package:social_media_app/screens/authentication/widgets/heading_text.dart';
  import 'package:social_media_app/screens/authentication/widgets/or_line.dart';
  import 'package:social_media_app/widgets/common/appname_text.dart';

  class RegistrationPage extends StatefulWidget {
    const RegistrationPage({super.key});

    @override
    State<RegistrationPage> createState() => _RegistrationPageState();
  }

  class _RegistrationPageState extends State<RegistrationPage> {
    final formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController firstnameController = TextEditingController();
    TextEditingController lastnameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController rePasswordController = TextEditingController();
    FocusNode emailNode = FocusNode();
    FocusNode firstnameNode = FocusNode();
    FocusNode lastnameNode = FocusNode();
    FocusNode passwordNode = FocusNode();
    FocusNode rePasswordNode = FocusNode();
    
    bool loading = false; 
    bool showPassword = false;
    bool showConfirmPassword = false;
    Uint8List? image;

    @override
    void dispose() {
      emailController.dispose();
      firstnameController.dispose();
      lastnameController.dispose();
      passwordController.dispose();
      rePasswordController.dispose();
      
      emailNode.dispose();
      firstnameNode.dispose();
      lastnameNode.dispose();
      passwordNode.dispose();
      rePasswordNode.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      spacing: 10.0,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // App Name
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: AppnameText()
                        ),
                        
                        // Heading/Welcome
                        HeadingText(heading: "Register", subheading: "Create a new account to join our community."),
                        SizedBox(height: 20),
                
                        // Profile Photo
                        GestureDetector(
                          onTap: () => selectImage(),
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 49.0,
                                    backgroundImage: image != null ? MemoryImage(image!) : null,
                                    child: image == null ? Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text("Select Photo", textAlign: TextAlign.center,),
                                    ) : null,
                                  ),
                                ),
                              ),
                              image == null
                              ? Positioned(
                                  bottom: 0,
                                  right: 10,
                                  child: Icon(
                                    Icons.add_a_photo_outlined,
                                    color: Theme.of(context).primaryColor ,
                                  ),
                                )
                              : SizedBox(),
                            ],
                          ),
                        ),

                        // Email
                        CustomTextBox(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          node: emailNode,
                          label: "Email*",
                          submit: () => FocusScope.of(context).requestFocus(firstnameNode),
                          validator: (email) => Validators.emailValidator(email),
                        ),
                        
                        // First and Last Names
                        Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: CustomTextBox(
                                controller: firstnameController,
                                node: firstnameNode,
                                label: "First Name*",
                                submit: () => FocusScope.of(context).requestFocus(lastnameNode),
                                validator: (fname) => Validators.nameValidator(fname),
                              ),
                            ),
                            Flexible(
                              child: CustomTextBox(
                                controller: lastnameController,
                                node: lastnameNode,
                                label: "Last Name*",
                                submit: () => FocusScope.of(context).requestFocus(passwordNode),
                                validator: (lname) => Validators.nameValidator(lname),
                              ),
                            ),
                          ],
                        ),
                        
                        // Password
                        CustomTextBox(
                          controller: passwordController,
                          node: passwordNode,
                          label: "Password*",
                          submit: () => FocusScope.of(context).requestFocus(rePasswordNode),
                          validator: (password) => Validators.passwordValidator(password),
                          obscureText: !showPassword,
                          suffixIcon: passwordVisibility( showPassword ),
                          suffixPress: () => setState(() => showPassword = !showPassword),
                        ),
                        
                        // Re-enter password
                        CustomTextBox(
                          controller: rePasswordController,
                          node: rePasswordNode,
                          label: "Re-enter Password*",
                          submit: () => FocusScope.of(context).unfocus(),
                          validator: (rePassword) => 
                            Validators.rePasswordValidator(
                              passwordController.text, 
                              rePassword
                            ),
                          obscureText: !showConfirmPassword,
                          suffixIcon: passwordVisibility( showConfirmPassword ),
                          suffixPress: () => setState(() => showConfirmPassword = !showConfirmPassword),
                        ),      
                
                
                        // Submit button
                        SizedBox(
                          width: double.maxFinite,
                          child: FilledButton(
                            onPressed: register,
                            child: loading 
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                                : Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text("Register", style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                            ),
                          ),
                        ),
                
                        // bottom 
                        OrLine(),
                        
                        ClickableRichText(
                          simpleText: "Already have an account? ", 
                          clickableText: "Log in here", 
                          pathName: 'login'
                        ),
                      ],
                    ), 
                  ),
                ),
              ),
            ),
        )
      );
    }


    void selectImage() async{ 
      Uint8List? img = await pickImage( ImageSource.gallery );
      setState(() {
        image = img;
      });
    }

    Future register() async{
      try {
        bool submitSuccess = Validators.submit(
          context: context,
          formKey: formKey,
        );
      
        if(submitSuccess){
          setState(() {
            loading = true;
          });

          String message = await AuthMethods().registerUser(
            firstname : firstnameController.text.trim(),
            lastname : lastnameController.text.trim(),
            email : emailController.text.trim(),
            password: passwordController.text,
            file: image,
          );

          // navigating to homepage
          if(!mounted) return;
          Navigator.pushReplacementNamed(
            context, 
            '/start', 
            arguments: {"name": firstnameController.text.trim() }
          );

          // Showing snackbar
          showSnackBar(context, message);

          Validators.clearControllers( 
            formKey: formKey,
            controllers: [
              emailController,
              firstnameController,
              lastnameController,
              passwordController,
              rePasswordController,
            ]
          );
        }
      } catch(e) {
        String message = e.toString();
        showSnackBar(context, message);
      } finally {
        setState(() {
          loading = false;
        });
      }
    }


    IconData passwordVisibility (bool value) => value ? Icons.visibility : Icons.visibility_off;
  }