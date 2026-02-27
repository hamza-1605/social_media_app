import 'package:flutter/material.dart';
import 'package:social_media_app/core/resources/auth_methods.dart';
import 'package:social_media_app/models/user.dart';

class UserProvider extends ChangeNotifier{
  User? _user;
  User? get getUser => _user;          // nullable — use when loading state matters
  User get user => _user!;             // non-null — use only after confirmed loaded

  bool get isLoaded => _user != null;
  
  final AuthMethods _authMethods = AuthMethods();


  Future<void> refreshUser() async{
    User? refreshedUser = await _authMethods.getUserDetails();
    _user = refreshedUser;
    notifyListeners();
  }
}