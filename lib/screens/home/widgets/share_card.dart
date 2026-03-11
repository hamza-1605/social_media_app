import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/constants/links.dart';
import 'package:social_media_app/widgets/common/appname_text.dart';

class ShareCard extends StatelessWidget {
  const ShareCard({
    super.key,
    required this.firstname,
    required this.lastname,
    required this.caption,
    required this.profileUrl,
    required this.postUrl,
    required this.username,
    required this.primaryColor,
    required this.bgColor
  });

  final String firstname;
  final String lastname;
  final String username;
  final String? caption;
  final String? profileUrl;
  final String? postUrl;
  final Color primaryColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: bgColor.withAlpha(150),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// Header
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: profileUrl == null
                    ? CachedNetworkImageProvider(Links().genericUser)
                    : CachedNetworkImageProvider(profileUrl!),
              ),

              const SizedBox(width: 10),

              Text(
                "$firstname $lastname",
                style: TextStyle(
                  color: primaryColor ,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Post Content
          if (postUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: postUrl!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: AppColors.lightGrey),
              ),
            )
          else
            Container(
              // height: 200,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                caption!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          if (postUrl != null) const SizedBox(height: 15),

          /// Caption for image posts
          if (postUrl != null)
            Text(
              caption!,
              style: TextStyle(
                color: primaryColor,
                fontSize: 14,
              ),
            ),

          const SizedBox(height: 20),

          /// Branding
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "@$username",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold
                ),
              ),

              const AppnameText(),
            ],
          )
        ],
      ),
    );
  }
}