import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media_app/widgets/common/appname_text.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.toggleTheme});
  
  final Function(bool) toggleTheme;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =    Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: AppnameText(),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.settings, size: 30.0),
            title: Text("Settings" , style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SwitchListTile(
              title: Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
              value: isDarkMode, 
              onChanged: (value) {
                widget.toggleTheme(value);
              },
            ),
          ),

          SizedBox(height: 10),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ListTile(
              title: Text("Log out" , style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              trailing: Icon(Icons.exit_to_app, size: 30.0),
              
              onTap: () => logOut(),
            ),
          ),
        ],
      ),
    );
  }



  void logOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

}