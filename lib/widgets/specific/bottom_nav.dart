import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(


      body: [
        HomePage(),
        SearchPage(),
        NotificationsPage(),
        ProfilePage(),
      ][currentIndex],


      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (value) => setState(() {
          currentIndex = value;
        }),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, size: 26,),
            selectedIcon: Icon(Icons.home, fontWeight: FontWeight.w700,), 
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.search, size: 26,), 
            selectedIcon: Icon(Icons.search, fontWeight: FontWeight.w700,), 
            label: "Search",
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined, size: 26,), 
            selectedIcon: Icon(Icons.notifications, fontWeight: FontWeight.w700,), 
            label: "Notifications",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, size: 26,), 
            selectedIcon: Icon(Icons.person, fontWeight: FontWeight.w700,), 
            label: "Profile",
          ),
        ] 
      ),
    );
  }
}