import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:social_media_app/core/resources/storage_methods.dart';
import 'package:social_media_app/models/post.dart';
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
}