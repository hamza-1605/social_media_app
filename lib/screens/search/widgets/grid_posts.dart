import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/widgets/common/center_loader.dart';

class GridPosts extends StatelessWidget {
  const GridPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("posts").orderBy("datePublished", descending: true).snapshots() , 
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
          child: StaggeredGrid.count(
            crossAxisCount: 3,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            children: List.generate(
              snaps.length, 
              (index) {
                final snap = snaps[index].data();
                return StaggeredGridTile.count(
                  crossAxisCellCount: (index % 5 == 0 ? 2 : 1), 
                  mainAxisCellCount: (index % 5 == 0 ? 2 : 1), 
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/viewpost', arguments: {"postid": snap['postid']});
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
                            border: BoxBorder.all(width: 0.5)
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
                  )
                );
              },
            ) 
          ),
        );
      },
    );
  }
}