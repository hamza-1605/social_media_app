import 'dart:async';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/constants/links.dart';
import 'package:social_media_app/core/providers/user_provider.dart';
import 'package:social_media_app/core/resources/firestore_methods.dart';
import 'package:social_media_app/core/utils/utils.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/screens/home/widgets/comments_section.dart';
import 'package:social_media_app/screens/home/widgets/icon_and_numbers.dart';
import 'package:social_media_app/screens/home/widgets/share_card.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.snap});
  final Map<String, dynamic> snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>{
  bool animationStart = false;
  final GlobalKey shareKey = GlobalKey();

  @override
  Widget build(BuildContext context){
    final userProv = Provider.of<UserProvider>(context);
    if (!userProv.isLoaded) {
      return const SizedBox.shrink();
    }
    
    final user = userProv.user;
    final uniqueId = widget.snap["email"].toString().split('@')[0];

    
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Name and PP
            ListTile(
              leading: GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context, 
                  '/viewProfile', 
                  arguments: {
                    "userid": widget.snap["userid"],
                  }
                ),
                child: CircleAvatar( 
                  radius: 22,
                  backgroundImage: widget.snap["profileUrl"] == null 
                    ? CachedNetworkImageProvider( Links().genericUser ) 
                    : null,
                  child: widget.snap["profileUrl"] != null 
                    ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: widget.snap["profileUrl"],
                        errorWidget: (context, url, error) => Icon(Icons.error_outline),
                        placeholder: (context, url) => Container(color: AppColors.lightGrey),
                        fit: BoxFit.cover,
                        height: 44, 
                        width: 44, 
                        ),
                      )
                    : null,
                ),
              ),
              title: GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context, 
                  '/viewProfile', 
                  arguments: {
                    "userid": widget.snap["userid"],
                  }
                ), 
                child: Text('${widget.snap["firstname"]} ${widget.snap["lastname"]}', style: TextStyle(fontWeight: FontWeight.w600),)
              ),
              trailing: user.userid == widget.snap["userid"] ? GestureDetector(
                onTap: () {
                  showDialog(context: context, builder: (context) {
                    return SimpleDialog(
                      contentPadding: EdgeInsets.all(15.0),
                      children: [
                        ListTile(
                          onTap: (){
                            FirestoreMethods().deletePost(widget.snap["postid"], user.userid);
                            Navigator.pop(context);
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
                      child: CachedNetworkImage(
                        imageUrl: widget.snap["postUrl"] ,
                        placeholder: (context, url) => Container(color: AppColors.lightGrey),
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
        
            // Bottom Row for buttons   &&    id & caption
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
                                bool liked = await FirestoreMethods().likePost(
                                  user.userid, widget.snap["likes"], widget.snap["postid"]
                                );
        
                                if( liked ){
                                  await FirestoreMethods().generateNotification(
                                    senderId:  user.userid, 
                                    receiverId: widget.snap["userid"], 
                                    postId: widget.snap["postid"], 
                                    notificationType: "like", 
                                    text: '${user.firstname} ${user.lastname} liked your post.',
                                  );
                                }
                                else{
                                  await FirestoreMethods().deleteLikeNotification(widget.snap["userid"], user.userid, widget.snap["postid"]);
                                }
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
                                    postId: widget.snap['postid'],
                                    posterId: widget.snap['userid']
                                  ),
                                );
                              },
                                  
                              child: IconAndNumbers(
                                amount: commentsLength.toString() , 
                                icon: Icon(Icons.chat_bubble_outline)
                              ),
                            ),
                            
                            // Share button
                            GestureDetector(
                              onTap: () async {
                                await sharePostCard();
                                print('POst kcard ShArEd!!');
                              },
                              child: IconAndNumbers(
                                amount: "",
                                icon: Icon(Icons.send_outlined),
                              ),
                            ),
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
                              postId: widget.snap['postid'],
                              posterId: widget.snap['userid']
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
        ),

        // shareCard
        Positioned(
          left: 10000,
          top:  10000,
          child: RepaintBoundary(
            key: shareKey,
            child: ShareCard(
              firstname: widget.snap["firstname"],
              lastname: widget.snap["lastname"],
              caption: widget.snap["caption"],
              username: uniqueId,
              profileUrl: widget.snap["profileUrl"],
              postUrl: widget.snap["postUrl"],
              primaryColor: Theme.of(context).colorScheme.primary,
              bgColor: Theme.of(context).scaffoldBackgroundColor
            ),
          ),
        )
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

    bool liked = await FirestoreMethods().likePost(
      user.userid, widget.snap["likes"], widget.snap["postid"]
    );

    if( liked ){
      await FirestoreMethods().generateNotification(
        senderId: user.userid, 
        receiverId: widget.snap["userid"], 
        postId: widget.snap["postid"], 
        notificationType: "like", 
        text: '${user.firstname} ${user.lastname} liked your post.',
      );
    }
    else{
      await FirestoreMethods().deleteLikeNotification(widget.snap["userid"], user.userid, widget.snap["postid"]);
    }
  }



  Future<void> sharePostCard() async {
    try {
      await Future.delayed(Duration(milliseconds: 50));

      final boundary =
          shareKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      if (boundary.debugNeedsPaint) {
        await Future.delayed(Duration(milliseconds: 500));
        print('Returning post card back');
        return sharePostCard();
      }

      final image = await boundary.toImage(pixelRatio: 3);
      print('Converted to Image');

      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      final bytes = byteData!.buffer.asUint8List();
      print('Converted to Uint8List');

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/postily_share.png');

      await file.writeAsBytes(bytes);

      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      print(e);
    }
  }

}