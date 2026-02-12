import 'package:flutter/material.dart';
import 'package:social_media_app/widgets/common/line_divider.dart';

class StoriesBar extends StatelessWidget {
  const StoriesBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 110,
          child: ListView.builder(
            itemCount: 8,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsetsGeometry.all( 8.0 ),
                child: Column(
                  spacing: 7,
                  children: [
                    GestureDetector(
                      onTap: (){
                        if(index != 0){
                          Navigator.pushNamed(context, '/story', arguments: {'id': index} );
                        }
                      },
                      child: CircleAvatar(
                        radius: 35.0,
                        child: index==0 
                          ? CircleAvatar(
                            radius: 33.0,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor ,
                            child: Icon(Icons.add),
                          ) 
                          : Hero(
                            tag: "story-pic$index",
                            child: CircleAvatar(
                              radius: 33.0,
                              backgroundColor: Colors.black,
                              backgroundImage: AssetImage("assets/images/cat.jpg"),
                            ),
                          ) 
                      ),
                    ),
                    Text(
                      index==0 ? "Add Story" : 
                      "Story #$index",
                      style: TextStyle(
                        fontSize: 12
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        LineDivider()
      ],
    );
  }
}