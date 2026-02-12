import 'package:flutter/material.dart';
import 'package:social_media_app/screens/home/widgets/post_card.dart';

class ViewPost extends StatelessWidget {
  const ViewPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: const PostCard(),
      ),
    );
  }
}