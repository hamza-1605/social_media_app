import 'package:flutter/material.dart';
import 'package:social_media_app/widgets/common/custom_button.dart';

class FollowButtonsRow extends StatelessWidget {
  const FollowButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        spacing: 5,
        children: [
          CustomButton( btnName: "Edit Profile" ),
          CustomButton( btnName: "Share Profile" ),
        ],
      ),
    );
  }
}




// return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Row(
//         spacing: 5,
//         children: [
//           CustomButton( btnName: "Follow" ),
//           CustomButton( btnName: "Message" ),
//           Container(
//             padding: EdgeInsetsGeometry.all(8.0),
//             decoration: BoxDecoration(
//               border: BoxBorder.all(color: AppColors.middlewareGrey, width: 0.5),
//               borderRadius: BorderRadiusGeometry.all(Radius.circular(10.0)),
//             ),
//             child: Icon(Icons.person_add_alt_1)
//           )
//         ],
//       ),
//     );