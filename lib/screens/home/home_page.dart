import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/providers/user_provider.dart';
import 'package:social_media_app/screens/home/widgets/post_card.dart';
// import 'package:social_media_app/screens/home/widgets/stories_bar.dart';
import 'package:social_media_app/widgets/common/appname_text.dart';
import 'package:social_media_app/widgets/common/center_loader.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedUser = context.watch<UserProvider>().getUser!;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: AppnameText(),
            centerTitle: true,
            pinned: false,
          ),
          // SliverToBoxAdapter(
          //   child: StoriesBar(),
          // ),
          
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("posts").orderBy("datePublished", descending: true).snapshots() , 
            builder: (context, snapshot) {
              
              if(snapshot.connectionState == ConnectionState.waiting){
                return SliverToBoxAdapter(
                  child: const CenterLoader()
                );
              }

              if (snapshot.hasData) {
                final allPosts = snapshot.data!.docs;
                final filteredPosts = allPosts
                    .where( (doc) => loggedUser.following.contains(doc['userid']) )
                    .toList();

                if (filteredPosts.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 60),
                      child: Center(
                        child: Text(
                          "Follow some more people to see some posts in your feed.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  );
                }

                return SliverList.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 10.0),
                  itemCount: filteredPosts.length,
                  itemBuilder: (context, index) {
                    final snap = filteredPosts[index].data();
                    return PostCard(snap: snap);
                  },
                );
              }


              return SliverToBoxAdapter(child: Center(child: Text("Some unknown error occurred!")));
            },
          ),
        ]
      ),
    );
  }
}