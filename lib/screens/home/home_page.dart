import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/screens/home/widgets/post_card.dart';
import 'package:social_media_app/screens/home/widgets/stories_bar.dart';
import 'package:social_media_app/widgets/common/appname_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: AppnameText(),
            centerTitle: true,
            pinned: false,
          ),
          SliverToBoxAdapter(
            child: StoriesBar(),
          ),
          
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("posts").orderBy("datePublished", descending: true).snapshots() , 
            builder: (context, snapshot) {
              
              if(snapshot.connectionState == ConnectionState.waiting){
                return SliverToBoxAdapter(
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if(snapshot.hasData){
                if(snapshot.data!.docs.isEmpty) return SliverToBoxAdapter(child: Center(child: Text("No posts to show.")));

                return SliverList.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 10.0),
                  itemCount : snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                      return PostCard(
                        snap: snapshot.data!.docs[index].data(),
                      );
                  }, 
                );
              }

              return SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
            },
          ),
        ]
      ),
    );
  }
}