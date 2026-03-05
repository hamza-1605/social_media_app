import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/constants/links.dart';
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
  Widget build(BuildContext context){
    final userProv = Provider.of<UserProvider>(context);
    if (!userProv.isLoaded) {
      return const SizedBox.shrink();
    }
    
    final user = userProv.user;
    final uniqueId = widget.snap["email"].toString().split('@')[0];

    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Name and PP
        ListTile(
          leading: CircleAvatar( 
            radius: 22,
            backgroundImage: widget.snap["profileUrl"] == null 
              ? NetworkImage( Links().genericUser ) 
              : null,
            child: widget.snap["profileUrl"] != null 
              ? ClipOval(
                child: Image.network( 
                  widget.snap["profileUrl"],
                  fit: BoxFit.cover,
                  height: 44, 
                  width: 44, 
                  ),
                )
              : null,
          ),
          title: Text('${widget.snap["firstname"]} ${widget.snap["lastname"]}', style: TextStyle(fontWeight: FontWeight.w600),),
          trailing: user.userid == widget.snap["userid"] ? GestureDetector(
            onTap: () {
              showDialog(context: context, builder: (context) {
                return SimpleDialog(
                  contentPadding: EdgeInsets.all(15.0),
                  children: [
                    ListTile(
                      onTap: (){
                        FirestoreMethods().deletePost(widget.snap["postid"]);
                        Navigator.pop(context);
                      },
                      leading: Icon(Icons.delete_outline),
                      title: Text('Delete Post'),
                    ),
                  ],
                );
              },);
            },
            child: Icon(
              Icons.more_vert
            )
          ) : SizedBox.shrink(),
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
                  onDoubleTap: () => likeAction( user ),
                  child: Image.network(
                    widget.snap["postUrl"] ,
                    fit: BoxFit.contain,
                  ),
                ),
                GestureDetector(
                  onDoubleTap: () => likeAction( user ),
                  child: AnimatedOpacity(
                    opacity: animationStart ? 1 : 0, 
                    duration: Duration(milliseconds: 250),
                    child: Icon(Icons.favorite, size: 100, color: Theme.of(context).scaffoldBackgroundColor),
                  ),
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
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').doc(widget.snap['postid']).collection('comments').snapshots(),
            builder: (context, asyncSnapshot) {
              if(!asyncSnapshot.hasData){
                return SizedBox.shrink();
              }

              final commentsLength = asyncSnapshot.data!.docs.length;
              return Column(
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
                              user.userid, widget.snap["likes"], widget.snap["postid"]
                            );
                          },
                          child: IconAndNumbers(
                            amount: widget.snap["likes"].length.toString(), 
                            icon: widget.snap["likes"].contains(user.userid) 
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
                              builder: (context) => CommentsSection(
                                postId: widget.snap['postid']
                              ),
                            );
                          },
                              
                          child: IconAndNumbers(
                            amount: commentsLength.toString() , 
                            icon: Icon(Icons.chat_bubble_outline)
                          ),
                        ),
                        IconAndNumbers(amount: "", icon: Icon(Icons.send_outlined)),
                      ],
                    ),
                  ),
              
                  // id & caption
                  RichText(
                    text: TextSpan(
                      text:  widget.snap["postUrl"] != null ? "$uniqueId\t\t" : "$uniqueId\tshared a thought!",
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
              
                  // view all comments
                  commentsLength >= 2 ? InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        isDismissible: true,
                        useSafeArea: false,
                        showDragHandle: true,
                        enableDrag: true,
                        isScrollControlled: true,
                  
                        context: context,
                        builder: (context) => CommentsSection(
                          postId: widget.snap['postid']
                        ),
                      );
                    },
                    child: Opacity(
                      opacity: 0.7,
                      child: Text('View all $commentsLength comments')
                    ),
                  ) : SizedBox.shrink(),
                  
                  // Date Published
                  Opacity(
                    opacity: 0.5,
                    child: Text( 
                      DateFormat.yMMMMd().format( 
                        widget.snap["datePublished"].toDate() 
                      ) 
                    ),
                  ),
                ]
                
              );
            }
          ),
        ),
      ],
    );
  }



  void likeAction(User user) async{
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
      user.userid, widget.snap["likes"], widget.snap["postid"]
    );
  }

}