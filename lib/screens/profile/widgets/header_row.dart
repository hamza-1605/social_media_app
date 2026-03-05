import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/links.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/screens/profile/widgets/numbers_column.dart';

class HeaderRow extends StatelessWidget {
  const HeaderRow({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric( horizontal: 20.0, vertical: 10.0 ),
          child: CircleAvatar(
            radius: 50.0,
            backgroundImage: NetworkImage(
              user.photoUrl ?? Links().genericUser,
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumbersColumn( number: user.postsCount, label: "Posts" ),
              InkWell(
                onTap: () => Navigator.pushNamed(
                  context, 
                  '/followList',
                  arguments: {
                    "users" : user.followers,
                    "heading" : "${user.followers.length} Followers",
                  }
                ),
                child: NumbersColumn( number: user.followers.length , label: "Followers" )
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(
                  context, 
                  '/followList',
                  arguments: {
                    "users" : user.following,
                    "heading" : "${user.following.length} Following",
                  }
                ),
                child: NumbersColumn( number: user.following.length , label: "Following" )
              ),
            ]
          ),
        ),
      ],
    );
  }
}