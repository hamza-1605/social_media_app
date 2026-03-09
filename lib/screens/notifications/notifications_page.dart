import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/providers/user_provider.dart';
import 'package:social_media_app/widgets/common/center_loader.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().getUser! ;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.notifications, size: 30,),
        title: Text("Notifications" , style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        centerTitle: true,
        toolbarHeight: 50,
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').doc(user.userid).collection('notifications').orderBy('createdAt', descending: true).snapshots() ,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return CenterLoader();
            }
            if (!asyncSnapshot.hasData){
              return Center(child: Text('You have no notifications.'));
            }

            final notifList = asyncSnapshot.data!.docs ;
            return ListView.separated(
              itemBuilder: (context, index) {
                final notification = notifList[index];
                
                final icon = notification['notificationType'] == 'like' ? Icons.favorite 
                  : notification['notificationType'] == 'comment' ? Icons.message_rounded : Icons.person_add;
                
                final date = '${DateFormat.yMd().format(
                  notification['createdAt'].toDate()
                )}, ${DateFormat.Hm().format(
                  notification['createdAt'].toDate() 
                )}';

                final textButton = notification['postId'] != null 
                  ? OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/viewpost', arguments: { "postid" : notification["postId"]}),
                    child: Text('View Post')
                  )  
                  : OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/viewProfile', arguments: { "userid" : notification["senderId"]}),
                    child: Text('View Profile')
                  );


                return Card(
                  child: ListTile(
                    leading: Icon( icon , size: 30,) ,
                    title: Text( notification['text'] , style: TextStyle(fontWeight: FontWeight.w700) ),
                    subtitle: Text( date ),

                    trailing: textButton
                  ),
                );
              }, 
              separatorBuilder: (context, index) => SizedBox(height: 10.0), 
              itemCount: notifList.length
            );
          }
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