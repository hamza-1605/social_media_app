import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/screens/profile/widgets/follow_buttons_row.dart';
import 'package:social_media_app/screens/profile/widgets/header_row.dart';
import 'package:social_media_app/screens/profile/widgets/name_and_about.dart';

class ProfileAppbar extends StatefulWidget {
  const ProfileAppbar({super.key});

  @override
  State<ProfileAppbar> createState() => _ProfileAppbarState();
}

class _ProfileAppbarState extends State<ProfileAppbar> {
  User? user;
  String name = "";
  late Future<Map<String, dynamic>?> futureUser;
  
  Future<Map<String, dynamic>?> getCurrentUserDetails() async{
    // current user
    user = FirebaseAuth.instance.currentUser;   // print("Auth user: $user");
    if (user == null) return null;              // couldn't find user in firebaseAuth
    
    // getting the user from id, from the 'users' database  -> 
    DocumentSnapshot dbUser = await FirebaseFirestore.instance.collection('users')
      .doc(user!.uid)
      .get();

    return dbUser.data() as Map<String, dynamic>?;    
    // dbUser = dbUser.data()
    // print("Firestore data: ${dbUser.data()}");
    // final data = dbUser.data() as Map<String, dynamic>;
  }
  
  @override
  void initState() {
    super.initState();
    futureUser = getCurrentUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      
      title: FutureBuilder<Map<String, dynamic>?>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: AppColors.logoColor,
                strokeWidth: 2,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Text("No Name");
          }

          final data = snapshot.data!;
          final name = "${data["firstname"]} ${data["lastname"]}";

          return Text(
            name,
            style: TextStyle(fontWeight: FontWeight.w700),
          );
        },
      ),

      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, "/settings");
          },
          child: Icon(Icons.settings)
        ),
      ],
      actionsPadding: EdgeInsets.only(right: 10.0),
      expandedHeight: 330,
      // pinned: true,

      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight - 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderRow(),
                NameAndAbout( email: user?.email ?? "" ),
                Spacer(),
                FollowButtonsRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}