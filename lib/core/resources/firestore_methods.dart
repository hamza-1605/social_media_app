import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:social_media_app/core/resources/storage_methods.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/models/user.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future<String> uploadPost({
    Uint8List? image,
    String? profileUrl,
    required String userid,
    required String caption,
    required String firstname,
    required String lastname,
    required String email,
  }) async{
    String res = "Some error occured";
    try {
      String postid = Uuid().v1();
      String? postUrl;

      if(image != null){
        postUrl = await StorageMethods()
                        .uploadImageToCloudinary(isPost: true, image: image, fileName: postid);
      }

      Post post = Post(
        firstname: firstname, 
        lastname: lastname,
        email: email, 
        postid: postid, 
        userid: userid, 
        caption: caption, 
        likes: [], 
        datePublished: DateTime.now(),
        postUrl: postUrl,
        profileUrl: profileUrl,
      );

      await firestore.collection('posts').doc(postid).set( post.toJson() );

      res = "success";
      return res;
    } catch (err) {
      res = err.toString();
      return res;
    }
  } 



  Future<void> likePost( String uid, List likes, String postId ) async{
    try {
      if( likes.contains(uid) ){
        await firestore.collection("posts").doc(postId).update({
          "likes" : FieldValue.arrayRemove([uid])
        });
      }
      else{
        await firestore.collection("posts").doc(postId).update({
          "likes" : FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }


  Future<void> postComment( String postId, User commentator, String text ) async{
    try {
      String commentId = const Uuid().v1();

      await firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
        "postId" : postId,
        "commentText" : text,
        "userid" : commentator.userid,
        "username" : commentator.email.split('@').first,
        "photoUrl" : commentator.photoUrl,
        "datePublished" : DateTime.now(),
        "likes" : []
      });

      print("Firebase saved comment successfully");

    } catch (e) {
      print(e.toString());
    }
  }


  Future<void> likeComment( String uid, List likes, String postId, String commentId ) async{
    try {
      if( likes.contains(uid) ){
        await firestore.collection("posts").doc(postId).collection('comments').doc(commentId).update({
          "likes" : FieldValue.arrayRemove([uid])
        });
      }
      else{
        await firestore.collection("posts").doc(postId).collection('comments').doc(commentId).update({
          "likes" : FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async{
    try {
      await firestore.collection('posts').doc(postId).delete() ;
    } catch (e) {
      print(e.toString()) ;
    }
  }
  
  Future<void> deleteComment(String postId, String commentId) async{
    try {
      await firestore.collection('posts').doc(postId).collection('comments').doc(commentId).delete() ;
    } catch (e) {
      print(e.toString()) ;
    }
  }


  Future<void> followUser( String userid, String followingId) async{
    try {
      DocumentSnapshot snap = await firestore.collection('users').doc(userid).get();
      List myfollowing = (snap.data()! as dynamic)['following'];

      if( myfollowing.contains(followingId) ){
        await firestore.collection('users').doc(followingId).update({
          "followers" : FieldValue.arrayRemove([userid])
        });

        await firestore.collection('users').doc(userid).update({
          "following" : FieldValue.arrayRemove([followingId])
        });
      }
      else{
        await firestore.collection('users').doc(followingId).update({
          "followers" : FieldValue.arrayUnion([userid])
        });

        await firestore.collection('users').doc(userid).update({
          "following" : FieldValue.arrayUnion([followingId])
        });
      }

    } catch (e) {
      print(e.toString());
    }
  }
}