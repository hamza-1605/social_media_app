
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/core/providers/user_provider.dart';
import 'package:social_media_app/core/theme/app_theme.dart';
import 'package:social_media_app/core/utils/error_page.dart';
import 'package:social_media_app/routes/app_routes.dart';
import 'package:social_media_app/widgets/common/appname_text.dart';
import 'package:social_media_app/screens/authentication/login_page.dart';
import 'package:social_media_app/widgets/specific/bottom_nav.dart';

class MyApp extends StatefulWidget{
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  ThemeMode? myThemeMode;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    initializePreferences();
    addData();
  }


  @override
  Widget build(BuildContext context) {
    if (myThemeMode == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: Center(child: AppnameText(),)),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Postily',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: myThemeMode!,
      
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if(snapshot.hasData){
            return BottomNav();
          }

          return LoginPage();
        },
      ),
      
      onGenerateRoute: (settings) =>  AppRoutes.generateRoutes( settings , toggleTheme ) ,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => ErrorPage(keyword: "error"),
        );
      },
    );
  }
  


  void initializePreferences() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;

    setState(() {
      myThemeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      currentUser = FirebaseAuth.instance.currentUser;
    });
  }


  void toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);

    setState(() {
      myThemeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }


  Future<void> addData() async{
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

}