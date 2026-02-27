import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/providers/user_provider.dart';
import 'package:social_media_app/core/resources/firestore_methods.dart';
import 'package:social_media_app/core/utils/utils.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/screens/home/widgets/comments_section.dart';
import 'package:social_media_app/screens/home/widgets/icon_and_numbers.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.snap});
  final Map<String, dynamic> snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>{
  bool animationStart = false;

  @override
  Widget build(BuildContext context) {
    final User? userProv = Provider.of<UserProvider>(context).getUser;
    if (userProv == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Name and PP
        ListTile(
          leading: CircleAvatar( 
            radius: 22,
            backgroundImage: widget.snap["profileUrl"] == null 
              ? NetworkImage("https://static.thenounproject.com/png/5400099-200.png") 
              : null,
            child: widget.snap["profileUrl"] != null 
              ? ClipOval(child: Image.network( widget.snap["profileUrl"] )) 
              : null,
          ),
          title: Text('${widget.snap["firstname"]} ${widget.snap["lastname"]}', style: TextStyle(fontWeight: FontWeight.w600),),
          trailing: Text("1h"),
        ),
    
        // Post Image
        widget.snap["postUrl"] != null
        ? AspectRatio(
          aspectRatio: 1,
          child:
            Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onDoubleTap: () async{
                    setState(() {
                      animationStart = true;
                    });
                    Timer(
                      Duration(milliseconds: 800), 
                      (){
                        if (!mounted) return;
                        setState(() {
                          animationStart = false;  
                        });
                      }
                    );
                    await FirestoreMethods().likePost(
                      userProv.userid, widget.snap["likes"], widget.snap["postid"]
                    );
                  },
                  child: Image.network(
                    widget.snap["postUrl"] ,
                    fit: BoxFit.contain,
                  ),
                ),
                AnimatedOpacity(
                  opacity: animationStart ? 1 : 0, 
                  duration: Duration(milliseconds: 250),
                  child: Icon(Icons.favorite, size: 100),
                ),
              ],
            ),
            )
        // If only text-based Post
        : Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              widget.snap["caption"],
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: getFontSize( widget.snap["caption"] ),
                fontWeight: FontWeight.w600
              ),
              textAlign: TextAlign.center,
            ),
          )
        ),

        // Bottom Row for buttons
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
                    // Like button
                    GestureDetector(
                      onTap: () async{
                        await FirestoreMethods().likePost(
                          userProv.userid, widget.snap["likes"], widget.snap["postid"]
                        );
                      },
                      child: IconAndNumbers(
                        amount: widget.snap["likes"].length.toString(), 
                        icon: widget.snap["likes"].contains(userProv.userid) 
                              ?   Icon(Icons.favorite, color: Colors.red)
                              :   Icon(Icons.favorite_border),
                      ),
                    ),
                    
                    // Comments Button + Open Section
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
                        icon: Icon(Icons.chat_bubble_outline)
                      )
                    ),
                    IconAndNumbers(amount: "", icon: Icon(Icons.send_outlined)),
                  ],
                ),
              ),
          
              // id & caption
              RichText(
                text: TextSpan(
                  text:  widget.snap["postUrl"] != null ? "h.s_1605\t\t" : "h.s_1605\tshared a thought!",
                  children: widget.snap["postUrl"] != null ? [
                    TextSpan(
                      text: widget.snap["caption"],
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
                    widget.snap["datePublished"].toDate() 
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