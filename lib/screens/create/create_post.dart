import 'package:flutter/material.dart';
import 'package:social_media_app/screens/create/widgets/post_box.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.post_add, size: 30.0,),
        title: Text("Create a Post"),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          spacing: 30.0,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PostBox(tag: "Upload an Image", icondata: Icons.upload, textOnly: false),
            PostBox(tag: "Share a thought", icondata: Icons.lightbulb_outline, textOnly: true),
          ],
        ),
      ),
    );
  }
}