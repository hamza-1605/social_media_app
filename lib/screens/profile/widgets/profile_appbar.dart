import 'package:flutter/material.dart';
import 'package:social_media_app/screens/profile/widgets/follow_buttons_row.dart';
import 'package:social_media_app/screens/profile/widgets/header_row.dart';
import 'package:social_media_app/screens/profile/widgets/name_and_about.dart';

class ProfileAppbar extends StatelessWidget {
  const ProfileAppbar({super.key, required this.username});
  final String username;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text( username,
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, "/settings");
          },
          child: Icon(Icons.settings)
        )
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
                NameAndAbout(),
                FollowButtonsRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}