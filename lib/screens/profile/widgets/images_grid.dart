import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/widgets/common/center_loader.dart';

class ImagesGrid extends StatelessWidget {
  const ImagesGrid({super.key, required this.userid});
  final String userid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("posts")
          .where("userid", isEqualTo: userid)
          .orderBy("datePublished", descending: true)
          .snapshots(),
                  
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CenterLoader();
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong!"));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No posts found."));
        }
        
        final snaps = snapshot.data!.docs;
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            children: List.generate(
              snaps.length, 
              (index) {
                final snap = snaps[index] ;
                return GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, '/viewpost', arguments: {"postid": snap['postid'] });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: snap['postUrl'] != null ?
                      Image.network(
                        snap['postUrl'],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {  // Image fully loaded
                            return child;
                          }
                          // While loading
                          return Container(
                            color: AppColors.lightGrey,
                          );
                        },
                      )
                      : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: BoxBorder.all(width: 0.5, color: AppColors.lightGrey),
                        ),
                        child: Center(
                          child: Text( 
                            snap['caption'].length > 15
                              ? '${snap['caption'].substring(0, 15)}...'
                              : snap['caption'], 
                            textAlign: TextAlign.center,
                          ),  
                        ),
                      ),
                  ),
                );
              },
            ) ,
          )
        );
      },
    );
  }
}