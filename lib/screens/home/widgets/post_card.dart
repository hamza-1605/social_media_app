import 'package:flutter/material.dart';
import 'package:social_media_app/screens/home/widgets/comments_section.dart';
import 'package:social_media_app/screens/home/widgets/icon_and_numbers.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name and PP
        ListTile(
          leading: CircleAvatar( 
            radius: 22,
            backgroundImage: AssetImage("assets/images/Hamza.png"), 
          ),
          title: Text("Hamza Sajid", style: TextStyle(fontWeight: FontWeight.w600),),
          subtitle: Text("Kashmir, Pakistan"),
          trailing: Text("1h"),
        ),

        // Image/post
        AspectRatio(
          aspectRatio: 1,
          child: Image.asset(
            "assets/images/kashmir.jpg",
            width: double.infinity,
            // fit: BoxFit.cover,
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Interaction buttons
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  spacing: 20.0,
                  children: [
                    IconAndNumbers(amount: "247", icon: Icons.favorite_border),
                    GestureDetector(
                      onTap: (){
                        showModalBottomSheet(
                          isDismissible: true,
                          useSafeArea: false,
                          showDragHandle: true,
                          enableDrag: true,
                          isScrollControlled: true,
          
                          context: context,
                          builder: (context) => CommentsSection(),
                        );
                      },
                      child: IconAndNumbers(
                        amount: "12", 
                        icon: Icons.chat_bubble_outline
                      )
                    ),
                    IconAndNumbers(amount: "7", icon: Icons.send_outlined),
                  ],
                ),
              ),
          
              // id & caption
              RichText(
                text: TextSpan(
                  text: "h.s_1605\t\t",
                  children: [
                    TextSpan(
                      text: "Saw this breathtaking scenary on my last visit to Kashmir.",
                      style: TextStyle(fontWeight: FontWeight.w500)
                    ),
                  ],
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                )
              ),
              Opacity(
                opacity: 0.7,
                child: Text("February 2, 2026")
              )
            ]
          ),
        ),
      ],
    );
  }
}