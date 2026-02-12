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
          SliverToBoxAdapter(
            child: Column(
              spacing: 10.0,
              children: [
                PostCard(),
                PostCard(),
                PostCard(),
                PostCard(),
                PostCard(),
                PostCard(),
              ],
            ),
          ),
        ]
      ),
    );
  }
}