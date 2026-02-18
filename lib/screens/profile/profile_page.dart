import 'package:flutter/material.dart';
import 'package:social_media_app/screens/profile/widgets/profile_appbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController myTab;

  @override
  void initState() {
    super.initState();
    myTab = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            ProfileAppbar(),

            // images grid
            SliverPadding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 10.0),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate( 
                  childCount: 19,
                  (context, index) {
                    return AspectRatio(
                      aspectRatio: 1,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/viewpost'),
                        child: Hero(
                          tag: 'hero-$index',
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage("assets/images/kashmir.jpg"), fit: BoxFit.cover)
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
