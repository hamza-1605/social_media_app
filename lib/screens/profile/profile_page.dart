import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/providers/user_provider.dart';
import 'package:social_media_app/core/resources/firestore_methods.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/screens/profile/widgets/header_row.dart';
import 'package:social_media_app/screens/profile/widgets/images_grid.dart';
import 'package:social_media_app/screens/profile/widgets/name_and_about.dart';
import 'package:social_media_app/widgets/common/center_loader.dart';
import 'package:social_media_app/widgets/common/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.userid});
  final String userid;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    if(!userProvider.isLoaded){
      return CenterLoader();
    }
    final loggedUser = userProvider.getUser! ;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users')
                .doc(widget.userid)
                .snapshots(), 
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator()
          );
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("User not found"));
        }

        final user = User.fromSnapToUser(snapshot.data!)! ;

        return Scaffold(
          appBar: AppBar(      
            title: Text(
              '${user.firstname} ${user.lastname}',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
            actions: [
              loggedUser.userid == widget.userid 
              ? GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, "/settings");
                  },
                  child: Icon(Icons.settings)
                )
              : SizedBox.shrink(),
            ],
            actionsPadding: EdgeInsets.only(right: 10.0),
          ),
        

          body: ListView(
            children: [
              HeaderRow( user: user ),
              NameAndAbout( email: user.email, bio: user.bio ?? "" ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  spacing: 5,
                  children: loggedUser.userid != widget.userid ? [
                    CustomButton(
                      btnName: loggedUser.following.contains(widget.userid) ?  "Unfollow" : "Follow", 
                      onTap: () async {
                        await FirestoreMethods().followUser(
                          loggedUser.userid,
                          widget.userid,
                        );
                        print("--------------Follow/Unfollow Button Clicked!----------------");
                        await userProvider.refreshUser(); 
                      },
                    ),
                  ]
                  : [
                    CustomButton(btnName: "Edit Profile", onTap: (){}),
                    CustomButton(btnName: "Share Profile", onTap: (){})
                  ]
                ),
              ),

              Divider(
                thickness: 0.5,
                height: 10,
              ),
              ImagesGrid( userid: user.userid ),
            ],
          ),
        );
      },
    );
  }
}