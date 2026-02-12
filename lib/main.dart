import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_media_app/app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  w
  runApp(const MyApp());
}