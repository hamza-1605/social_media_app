class User{
  final String firstname;
  final String lastname;
  final String email;
  final String userid;
  String? photoUrl;
  String? bio;
  final List followers;
  final List following;

  User({
    required this.firstname, 
    required this.lastname, 
    required this.email, 
    required this.userid, 
    this.photoUrl, 
    this.bio, 
    required this.followers, 
    required this.following
  });

  Map<String, dynamic> toJson () => {
    "firstname" : firstname, 
    "lastname" : lastname, 
    "email" : email, 
    "userid" : userid, 
    "bio" : bio, 
    "followers" : followers, 
    "following" : following, 
  };

}