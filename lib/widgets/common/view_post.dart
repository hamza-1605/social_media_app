import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/screens/home/widgets/post_card.dart';
import 'package:social_media_app/widgets/common/center_loader.dart';
// import 'package:social_media_app/screens/home/widgets/post_card.dart';

class ViewPost extends StatelessWidget {
  final String postid;
  const ViewPost({super.key, required this.postid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').doc(postid).snapshots(), 
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return CenterLoader();
            }

            final snap = snapshot.data!.data() as Map<String, dynamic>;
            return PostCard(snap: snap);
          },
        ),
        // child: const PostCard(),
      ),
    );
  }
}