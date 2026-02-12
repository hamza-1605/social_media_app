import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});
  
  final List<Map<String, dynamic>> notifications = [
    {
      "time" : "5m",
      "heading" : "Friend Request",
      "type" : "friend",
      "message" : "Ali send you a friend request."},
    {
      "time" : "33m",
      "heading" : "+1 Like",
      "type" : "like",
      "message" : "Mobeen liked your post."},
    {
      "time" : "2h",
      "heading" : "+1 Comment",
      "type" : "comment",
      "message" : "Ibbad commented on your photo."}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.notifications, size: 30,),
        title: Text("Notifications"),
        toolbarHeight: 50,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: Icon( getIcon( notifications[index]["type"] ) ),
                title: Text( notifications[index]["heading"] ),
                subtitle: Text( notifications[index]["message"] ),
                trailing: Text( notifications[index]["time"] ),
              ),
            );
          }, 
          separatorBuilder: (context, index) => SizedBox(height: 10.0), 
          itemCount: notifications.length
        ),
      ),
    );
  }


  IconData getIcon(String type) {
    switch (type) {
      case "friend":
        return Icons.person_add;
      case "like":
        return Icons.favorite;
      case "comment":
        return Icons.chat_bubble;
      default:
        return Icons.notifications;
    }
  }
}