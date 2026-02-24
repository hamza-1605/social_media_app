  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'package:social_media_app/core/providers/user_provider.dart';
  import 'package:social_media_app/screens/addPost/add_post.dart';
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
          AddPost(),
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
            NavigationDestination(
              icon: Icon(Icons.home_outlined, size: 35,),
              selectedIcon: Icon(Icons.home, fontWeight: FontWeight.w700, size: 35,), 
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.search, size: 35,), 
              selectedIcon: Icon(Icons.search, fontWeight: FontWeight.w700, size: 35,), 
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle_outline, size: 35,), 
              selectedIcon: Icon(Icons.add_circle_outlined, fontWeight: FontWeight.w700, size: 35,), 
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined, size: 35,), 
              selectedIcon: Icon(Icons.notifications, fontWeight: FontWeight.w700, size: 35,), 
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, size: 35,), 
              selectedIcon: Icon(Icons.person, fontWeight: FontWeight.w700, size: 35,), 
              label: "",
            ),
          ] 
        ),
      );
    }
  }