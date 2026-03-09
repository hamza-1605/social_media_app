import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String notificationId;
  final String senderId;
  final String receiverId;
  final String? postId;
  final String? commentId;
  final String notificationType;
  final String text;
  final bool isRead;
  final Timestamp createdAt;

  AppNotification({
    required this.notificationId, 
    required this.senderId, 
    required this.receiverId, 
    this.postId, 
    this.commentId,
    required this.notificationType, 
    required this.text, 
    required this.isRead, 
    required this.createdAt
  });


  Map<String, dynamic> notificationToJson(){
    return {
      "notificationId" : notificationId,
      "senderId" : senderId, 
      "receiverId" : receiverId, 
      "postId" : postId, 
      "commentId" : commentId,
      "notificationType" : notificationType, 
      "text" : text, 
      "isRead" : isRead, 
      "createdAt" : createdAt, 
    };
  }


  AppNotification jsonToNotification( Map<String, dynamic> json){
    return AppNotification(
      notificationId: json["notificationId"], 
      senderId: json["senderId"], 
      receiverId: json["receiverId"], 
      postId: json["postId"],
      commentId: json["commentId"],
      notificationType: json["notificationType"], 
      text: json["text"], 
      isRead: json["isRead"], 
      createdAt: json["createdAt"]
    );
  }

}