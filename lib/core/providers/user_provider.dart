import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/resources/auth_methods.dart';
import 'package:social_media_app/models/user.dart' as model;

class UserProvider extends ChangeNotifier{
  model.User? _user;
  model.User? get getUser => _user;          // nullable — use when loading state matters
  model.User get user => _user!;             // non-null — use only after confirmed loaded

  bool get isLoaded => _user != null;
  
  final AuthMethods _authMethods = AuthMethods();


  Future<void> refreshUser() async{
    final firebaseUser = FirebaseAuth.instance.currentUser ?? 
          await FirebaseAuth.instance.authStateChanges().first; 
    if (firebaseUser == null) return;
    
    model.User? refreshedUser = await _authMethods.getUserDetails();
    _user = refreshedUser;
    notifyListeners();
  }
}