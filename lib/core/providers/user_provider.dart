import 'package:flutter/material.dart';
import 'package:social_media_app/core/resources/auth_methods.dart';
import 'package:social_media_app/models/user.dart';

class UserProvider extends ChangeNotifier{
  User? _user;
  User? get getUser => _user;
  
  final AuthMethods _authMethods = AuthMethods();


  Future<void> refreshUser() async{
    User? refreshedUser = await _authMethods.getUserDetails();
    
    if (refreshedUser != null) {
      _user = refreshedUser;
      notifyListeners();
    }
  }
}