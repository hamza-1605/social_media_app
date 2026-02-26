  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
  import 'package:social_media_app/core/providers/user_provider.dart';
  import 'package:social_media_app/screens/create/create_post.dart';
  import 'package:social_media_app/screens/home/home_page.dart';
  import 'package:social_media_app/screens/notifications/notifications_page.dart';
  import 'package:social_media_app/screens/profile/profile_page.dart';
  import 'package:social_media_app/screens/search/search_page.dart';

  class BottomNav extends StatefulWidget {
    const BottomNav({super.key});

    @override
    State<BottomNav> createState() => _BottomNavState();
  }

  class _BottomNavState extends State<BottomNav> {
    int currentIndex = 0;

    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<UserProvider>(context, listen: false).refreshUser();
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(

        body: [
          HomePage(),
          SearchPage(),
          CreatePost(),
          NotificationsPage(),
          ProfilePage(),
        ][currentIndex],


        bottomNavigationBar: NavigationBar(
          height: 55.0,
          elevation: 20.0,
          selectedIndex: currentIndex,
          labelPadding: EdgeInsets.all(0),
          labelTextStyle: WidgetStatePropertyAll( TextStyle(fontSize: 0) ),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          onDestinationSelected: (value) => setState(() {
            currentIndex = value;
          }),
          destinations: [
            naviDestination( Icons.home_outlined, Icons.home ),
            naviDestination( Icons.search, Icons.search ),
            naviDestination( Icons.add_circle_outline, Icons.add_circle_outlined ),
            naviDestination( Icons.notifications_outlined, Icons.notifications ),
            naviDestination( Icons.person_outline, Icons.person ),
          ] 
        ),
      );
    }



    NavigationDestination naviDestination( IconData icon, IconData selectedIcon ) {
      return NavigationDestination(
        icon: Icon(icon, size: 35, fontWeight: FontWeight.w100, color: AppColors.lightGrey,),
        selectedIcon: Icon(selectedIcon, fontWeight: FontWeight.w700, size: 35,), 
        label: "",
      );
    }
  }