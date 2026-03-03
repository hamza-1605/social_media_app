import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/widgets/common/center_loader.dart';

class GridPosts extends StatelessWidget {
  const GridPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("posts").get() , 
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
                return StaggeredGridTile.count(
                  crossAxisCellCount: (index % 5 == 0 ? 2 : 1), 
                  mainAxisCellCount: (index % 5 == 0 ? 2 : 1), 
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: snaps[index]['postUrl'] != null ?
                      Image.network(
                        color: AppColors.lightGrey,
                        snaps[index]['postUrl'],
                        fit: BoxFit.cover,
                      )
                      : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: BoxBorder.all(width: 0.5)
                        ),
                        child: Center(
                          child: Text( 
                            snaps[index]['caption'].length > 15
                              ? '${snaps[index]['caption'].substring(0, 15)}...'
                              : snaps[index]['caption'], 
                            textAlign: TextAlign.center,
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