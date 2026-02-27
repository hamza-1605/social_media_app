import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String firstname;
  final String lastname;
  final String email;
  final String userid;
  final String postid;
  final String caption;
  final List likes;
  final DateTime datePublished;
  String? profileUrl;
  String? postUrl;


  Post({
    required this.firstname, 
    required this.lastname, 
    required this.email,
    required this.postid, 
    required this.userid, 
    required this.caption, 
    required this.likes,
    required this.datePublished, 
    this.postUrl,
    this.profileUrl
  });


  Map<String, dynamic> toJson () => {
    "firstname" : firstname, 
    "lastname" : lastname, 
    "email": email,
    "postid" : postid, 
    "userid" : userid, 
    "caption" : caption, 
    "likes" : likes,
    "datePublished" : datePublished, 
    "postUrl" : postUrl, 
    "profileUrl" : profileUrl
  };


  static Post fromSnapToPost(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic> ;
    return Post(
      firstname : snap["firstname"], 
      lastname : snap["lastname"], 
      email: snap["email"],
      postid : snap["postid"], 
      userid : snap["userid"], 
      caption : snap["caption"], 
      likes : snap["likes"],
      datePublished : snap["datePublished"], 
      postUrl : snap["postUrl"], 
      profileUrl : snap["profileUrl"]
    );
  }

}