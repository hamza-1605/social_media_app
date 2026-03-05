import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String firstname;
  final String lastname;
  final String email;
  final String userid;
  final int postsCount;
  String? photoUrl;
  String? bio;
  final List followers;
  final List following;
  late final List<String> searchIndex;


  User({
    required this.firstname, 
    required this.lastname, 
    required this.email, 
    required this.userid, 
    required this.postsCount,
    this.photoUrl, 
    this.bio, 
    required this.followers, 
    required this.following,
  }){ 
    searchIndex = _buildSearchIndex();
  }


  List<String> _buildSearchIndex() {
    final first = firstname.toLowerCase();
    final last = lastname.toLowerCase();
    final userid = email.split('@').first.toLowerCase();
    final lowerEmail = email.toLowerCase();
    final fullName = "$first $last";

    return [
      first,
      last,
      fullName,
      lowerEmail,
      userid,
    ];
  }


  Map<String, dynamic> toJson () => {
    "firstname" : firstname, 
    "lastname" : lastname, 
    "email" : email, 
    "userid" : userid,
    "postsCount" : postsCount, 
    // "bio" : bio,
    "photoUrl" : photoUrl,
    "followers" : followers, 
    "following" : following,
    "searchIndex": _buildSearchIndex(),
  };


  static User? fromSnapToUser(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    if (data == null) return null;
  
    final snap = snapshot.data() as Map<String, dynamic> ;
    return User(
      firstname: snap["firstname"] , 
      lastname: snap["lastname"], 
      email: snap["email"], 
      userid: snap["userid"], 
      followers: List<String>.from(snap["followers"]), 
      following: List<String>.from(snap["following"]),
      // bio: snap["bio"],
      photoUrl: snap["photoUrl"],
      postsCount: snap["postsCount"] ?? 0
    );
  }

}