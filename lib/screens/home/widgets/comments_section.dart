import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/constants/links.dart';
import 'package:social_media_app/core/providers/user_provider.dart';
import 'package:social_media_app/core/resources/firestore_methods.dart';
// import 'package:social_media_app/core/utils/utils.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/widgets/common/center_loader.dart';

class CommentsSection extends StatefulWidget {
  final String postId;
  const CommentsSection({super.key, required this.postId});

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}


class _CommentsSectionState extends State<CommentsSection> {  
  TextEditingController commentController = TextEditingController();
  late final Stream<QuerySnapshot<Map<String, dynamic>>> commentsStream;

  @override
  void initState() {
    super.initState();
    commentsStream = FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.postId)
                        .collection('comments')
                        .orderBy("datePublished" , descending: true)
                        .snapshots();
  }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
  final userProv = Provider.of<UserProvider>(context);
  if (!userProv.isLoaded) {
    return const SizedBox.shrink();
  }
    
  final User user = userProv.user;
    
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Comments" , style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700
          )),
    
          
          // List of Comments
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: commentsStream, 
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const CenterLoader();
                }          

                if(snapshot.hasData){
                  final snaps = snapshot.data!.docs ;
                  if(snaps.isEmpty){
                    return Center(child: const Text("No comments yet."));
                  }

                  return ListView.builder(
                    itemBuilder: (context, index) {
                    final snap = snaps[index].data(); 
                      return ListTile(
                        onLongPress: () async{
                          
                          if(user.userid == snap["userid"]){
                            showDialog(context: context, builder: (context) {
                              return SimpleDialog(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.delete_outline),
                                    title: Text("Delete Comment"),
                                    onTap: () => deleteComment(context, widget.postId, snaps[index].id ),
                                  ),
                                ],
                              );
                            },);
                          }
                        },
                        leading: CircleAvatar(
                          radius: 18,
                          child: ClipOval(
                            child: Image.network( snap["photoUrl"], fit: BoxFit.cover, height: 36, width: 36,),
                          ),
                        ),
                        title: Text( 
                          snap["username"],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700
                          ), 
                        ),
                        subtitle: Text(
                          snap["commentText"],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),  
                        ),
                        trailing: Column(
                          children: [
                            GestureDetector(
                              onTap: () async{
                                await FirestoreMethods().likeComment(
                                  user.userid, 
                                  snap["likes"], 
                                  widget.postId,
                                  snaps[index].id
                                  // snap[index].data()
                                );
                              },
                              child: snap["likes"].contains(user.userid) 
                                ?   Icon(Icons.favorite, color: Colors.red,)
                                :   Icon(Icons.favorite_border), 
                            ),
                            Text( snap["likes"].length.toString() ),
                          ],
                        ),
                        isThreeLine:  snap["commentText"].toString().length > 35,
                      );
                    },
                    itemCount: snaps.length
                  );
                }

                return Center(child: Text("An unknown error occurred."));
              },
            )
          ),


          // Add a Comment textfield
          SafeArea(
            top: false,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                border: BoxBorder.fromLTRB(
                  top: BorderSide(color: Theme.of(context).primaryColor , width: 1) 
                )
              ),
              margin: EdgeInsets.only( bottom: MediaQuery.viewInsetsOf(context).bottom ),
              padding: const EdgeInsets.all(8.0),
              
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 16,
                    child: ClipOval(
                      child: Image.network( user.photoUrl ?? Links().genericUser ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5.0),
                        hintText: "Comment as ${user.email.split('@').first}...",
                        suffixIcon: InkWell(
                          onTap: () => submitComment(context, user),
                          child: Icon(Icons.send)
                        ),
                        
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Future<void> submitComment(BuildContext context, User user) async{
    if( commentController.text.trim() != "" ){
      FocusScope.of(context).unfocus();
      
      await FirestoreMethods().postComment(
        widget.postId, 
        user, 
        commentController.text.trim(),
      );
      commentController.clear();
      
      // if(!context.mounted) return;
      // showSnackBar(context, "Comment posted successfully!");
    }
  }


  Future<void> deleteComment(BuildContext context, String postId, String commentId) async{
    Navigator.pop(context);
    FocusScope.of(context).unfocus();
    await FirestoreMethods().deleteComment(postId, commentId);
  }

}