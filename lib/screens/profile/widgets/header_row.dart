import 'package:flutter/material.dart';
import 'package:social_media_app/screens/profile/widgets/numbers_column.dart';

class HeaderRow extends StatelessWidget {
  const HeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric( horizontal: 20.0, vertical: 10.0 ),
          child: CircleAvatar(
            radius: 50.0,
            backgroundImage: AssetImage("assets/images/Hamza.png"),
            backgroundColor: Colors.grey,
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumbersColumn( number: "280" , label: "Posts" ),
              NumbersColumn( number: "5851" , label: "Followers" ),
              NumbersColumn( number: "3935" , label: "Following" ),
            ]
          ),
        ),
      ],
    );
  }
}