import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/providers/user_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    if(!userProvider.isLoaded){
      return SliverToBoxAdapter(child: const Center(
        child: CircularProgressIndicator()
      ));
    }

    final user = userProvider.user;

    return SliverAppBar(      
      title: Text(
        '${user.firstname} ${user.lastname}',
        style: TextStyle(fontWeight: FontWeight.w700),
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
                NameAndAbout( email: user.email ),
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