import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_media_app/core/utils/utils.dart';
import 'package:social_media_app/screens/home/widgets/comments_section.dart';
import 'package:social_media_app/screens/home/widgets/icon_and_numbers.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.snap});
  final Map<String, dynamic> snap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Name and PP
        ListTile(
          leading: CircleAvatar( 
            radius: 22,
            backgroundImage: snap["profileUrl"] ?? NetworkImage("https://static.thenounproject.com/png/5400099-200.png"), 
          ),
          title: Text('${snap["firstname"]} ${snap["lastname"]}', style: TextStyle(fontWeight: FontWeight.w600),),
          subtitle: Text("Kashmir, Pakistan"),
          trailing: Text("1h"),
        ),
    
        // Image/post
        snap["postUrl"] != null
        ? AspectRatio(
          aspectRatio: 1,
          child:
            Image.network(
                snap["postUrl"] ,
                fit: BoxFit.contain,
              ),
            )
        : Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              snap["caption"],
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: getFontSize( snap["caption"] ),
                fontWeight: FontWeight.w600
              ),
              textAlign: TextAlign.center,
            ),
          )
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
                    IconAndNumbers(amount: snap["likes"].toString(), icon: Icons.favorite_border),
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
                    IconAndNumbers(amount: "", icon: Icons.send_outlined),
                  ],
                ),
              ),
          
              // id & caption
              RichText(
                text: TextSpan(
                  text:  snap["postUrl"] != null ? "h.s_1605\t\t" : "h.s_1605\tshared a thought!",
                  children: snap["postUrl"] != null ? [
                    TextSpan(
                      text: snap["caption"],
                      style: TextStyle(fontWeight: FontWeight.w500)
                    ),
                  ] : [],
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                )
              ),
              InkWell(
                onTap: () {},
                child: Opacity(
                  opacity: 0.7,
                  child: Text("View all 12 comments")
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: Text( 
                  DateFormat.yMMMMd().format( 
                    snap["datePublished"].toDate() 
                  ) 
                ),
              ),
            ]
          ),
        ),
      ],
    );
  }
}