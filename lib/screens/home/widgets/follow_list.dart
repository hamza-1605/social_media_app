import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/links.dart';
import 'package:social_media_app/models/user.dart';

class FollowList extends StatelessWidget {
  const FollowList({super.key, required this.users, required this.heading});
  final List users; 
  final String heading;

  Future<User?> getUser(String userid) async{
    final document = await FirebaseFirestore.instance.collection('users').doc(userid).get();
    return User.fromSnapToUser(document);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(heading),
        centerTitle: true,
      ),

      body: users.isEmpty 
          ? Center(child: Text("None to display."),) 
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final uid = users[index];

          return FutureBuilder(
            future: getUser(uid),
            builder: (context, asyncSnapshot) {
              if(asyncSnapshot.connectionState == ConnectionState.waiting){
                return ListTile(
                  title: Text("Loading..."),
                  subtitle: Text("- - - - - -"),
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 20,
                  ),
                );
              }
              if(!asyncSnapshot.hasData){
                return SizedBox.shrink();
              }

              final user = asyncSnapshot.data!;
              return GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context, '/viewProfile' , 
                  arguments: {
                    "userid" : user.userid,
                    "email" : user.email,
                  } 
                ),

                child: ListTile(
                  title: Text( '${user.firstname} ${user.lastname}' ),
                  titleTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                  ),
                  subtitle: Text( user.email ),
                  leading: ClipOval(
                    child: Image.network(
                      user.photoUrl ?? Links().genericUser ,
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                      loadingBuilder: (context, child, loadingProgress) {
                        if(loadingProgress == null){
                          return child;
                        }

                        return CircularProgressIndicator();
                      },
                    )
                  ),
                ),
              );
            }
          );
        }
      ),
    );
  }
}