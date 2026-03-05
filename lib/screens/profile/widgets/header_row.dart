import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/links.dart';
import 'package:social_media_app/core/utils/utils.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/screens/profile/widgets/numbers_column.dart';

class HeaderRow extends StatelessWidget {
  const HeaderRow({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('posts')
                  .where("userid", isEqualTo: user.userid)
                  .get(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return SizedBox();
        }
        if(asyncSnapshot.hasError){
          showSnackBar(context, "error");
        }
        final posts = asyncSnapshot.data!.docs ;

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
                  NumbersColumn( number: posts.length, label: "Posts" ),
                  NumbersColumn( number: user.followers.length , label: "Followers" ),
                  NumbersColumn( number: user.following.length , label: "Following" ),
                ]
              ),
            ),
          ],
        );
      }
    );
  }
}