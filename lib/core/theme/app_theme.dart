import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';

class AppTheme {
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.white,
      brightness: Brightness.light,
      surface: Colors.white,
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.black),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color.fromARGB(255, 241, 239, 239),
      indicatorColor: Colors.blueAccent[100],

      iconTheme: WidgetStatePropertyAll( IconThemeData(
          color: Colors.black,
      )),
      labelTextStyle: WidgetStatePropertyAll( TextStyle(
        color: Colors.black
      )),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.buttonBlue,
        textStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18
        ),
      )
    ),

  );




  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
      brightness: Brightness.dark,
      surface: Colors.black,
      onPrimary: Colors.white
    ),
    
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color.fromARGB(255, 20, 20, 20),
      indicatorColor: Colors.blueAccent,

      iconTheme: WidgetStatePropertyAll( IconThemeData(
          color: Colors.white,
      )),
      labelTextStyle: WidgetStatePropertyAll( TextStyle(
        color: Colors.white
      )),
    ),
    
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.buttonBlue,
        foregroundColor: Colors.white,
        textStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18
        ),
      ),
    ),
    
    switchTheme: SwitchThemeData(
      trackColor: WidgetStatePropertyAll( AppColors.buttonBlue ),
      thumbColor: WidgetStatePropertyAll( Colors.white ),
    )
  );

}