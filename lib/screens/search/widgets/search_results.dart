import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/widgets/common/center_loader.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final searchText = text.toLowerCase();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
                .collection('users')
                .where("searchIndex", arrayContains: searchText)
                .snapshots(), 
      
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CenterLoader();
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        
        final users = snapshot.data!.docs;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index].data();
            return ListTile(
              title: Text( '${user["firstname"]} ${user['lastname']}' ),
              subtitle: Text( user["email"] ),
              leading: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage( user['photoUrl'] ?? "" ),
              ),
            );
          },
        );
      }
    );
  }
}