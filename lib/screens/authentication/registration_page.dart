import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/utils/validators.dart';
import 'package:social_media_app/screens/authentication/widgets/clickable_rich_text.dart';
import 'package:social_media_app/screens/authentication/widgets/custom_text_box.dart';
import 'package:social_media_app/screens/authentication/widgets/heading_text.dart';
import 'package:social_media_app/screens/authentication/widgets/or_line.dart';
import 'package:social_media_app/screens/authentication/widgets/select_gender.dart';
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
  
  String gender = "";
  DateTime? selectedDate;

  bool loading = false; 
  bool showPassword = false;
  bool showConfirmPassword = false;

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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                spacing: 20.0,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // App Name
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: AppnameText()
                  ),
                  
                  // Heading
                  HeadingText(heading: "Register", subheading: "Create a new account to join our community."),

                  // Email
                  CustomTextBox(
                    controller: emailController,
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

                  // Gender - Dropdown List
                  SelectGender(
                    gender: gender, 
                    onGenderChange: (value) => setState(() {
                      gender = value;
                    })
                  ),
                  
                  // Date Picker
                  Row(
                    spacing: 20.0,
                    children: [
                      Text(
                        "Date of Birth: ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ), 
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.middlewareGrey, width: 0.5),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                        child: GestureDetector(
                          onTap: selectDate, 
                          child: Text(
                            selectedDate != null
                              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                              : 'No date selected',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: AppColors.middlewareGrey
                            ),
                          ),
                        ),
                      ),
                    ],
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
    );
  }



  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1920),
      firstDate: DateTime(1920),
      lastDate: DateTime(2007, 12, 31),
    );

    setState(() {
      selectedDate = pickedDate;
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
        
        if(passwordController.text.trim() != rePasswordController.text.trim()){
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Registration Successful!"),
              behavior: SnackBarBehavior.floating,
            )
          );

          return;
        }
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(), 
          password: passwordController.text.trim(),
        );

        if(!mounted) return;
        Navigator.pushReplacementNamed(context, '/start', arguments: {"name": firstnameController.text.trim() });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration Successful!"),
            behavior: SnackBarBehavior.floating,
          )
        );

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
    } on FirebaseAuthException catch (e) {
      print('-------------------------');
      print(e);
      print('-------------------------');

      String message = "Registration failed";
      
      if(e.code == "email-already-in-use"){
        message = "This email is already in use.";
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






// List<String> radioOptions = ["Male" , "Female" , "Not rather say"];
// String currentRadio = "Male" ;

                  // Gender - Radio Buttons
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       "Gender: ",
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w600,
                  //         color: Colors.black87,
                  //       ),
                  //     ), 
                  //     RadioGroup(
                  //       groupValue: currentRadio,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           currentRadio = value!;
                  //         });
                  //       },
                  //       child: Column(
                  //         children: radioOptions.map( (option){
                  //           return RadioListTile(
                  //             activeColor: Colors.blueAccent,
                  //             value: option,
                  //             title: Text(option),
                  //           );
                  //         }).toList(),
                  //       ),
                  //     ),
                  //   ],
                  // ),