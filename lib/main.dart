import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/app.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:social_media_app/core/providers/user_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");                      // loading env files
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,      // initializing firebase
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,                           // Straight orientation
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp()
    )
  );
}