import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/error_page.dart';
import 'package:social_media_app/screens/authentication/login_page.dart';
import 'package:social_media_app/screens/authentication/registration_page.dart';
import 'package:social_media_app/screens/authentication/widgets/forgot_password_page.dart';
import 'package:social_media_app/screens/home/widgets/story_preview.dart';
import 'package:social_media_app/screens/profile/widgets/settings_page.dart';
import 'package:social_media_app/screens/profile/widgets/view_post.dart';
import 'package:social_media_app/widgets/specific/bottom_nav.dart';

class AppRoutes {
  static Route<dynamic> generateRoutes(RouteSettings settings, Function(bool) toggleTheme){
    switch(settings.name){
      case '/login' :
        return MaterialPageRoute(builder: (context) => LoginPage());
      
      case '/register' :
        return MaterialPageRoute(builder: (context) => RegistrationPage());

      case '/start':
        return MaterialPageRoute(builder: (context) => BottomNav());

      case '/settings':
        return MaterialPageRoute(builder: (context) => SettingsPage(toggleTheme: toggleTheme));

      case '/viewpost':
        return MaterialPageRoute(builder: (context) => ViewPost());


      case '/story':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (context) => StoryPreview( id: args["id"] ));

      case '/forgot-password':
        return MaterialPageRoute(builder: (context) => ForgotPasswordPage());
        
      default:
        return MaterialPageRoute(builder: (context) => ErrorPage(keyword: "error"));
    }
  }
}