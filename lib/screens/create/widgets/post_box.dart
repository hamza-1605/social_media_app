import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/core/theme/app_fonts.dart';

class PostBox extends StatelessWidget {
  const PostBox({super.key, required this.tag, required this.icondata, required this.textOnly});
  final String tag;
  final IconData icondata;
  final bool textOnly;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, "/addpost", arguments: {"textOnly" : textOnly});
      },
      child: DottedBorder(
          options: RectDottedBorderOptions(
            padding: EdgeInsets.all(20.0),
            dashPattern: [5,5],
            color: Theme.of(context).appBarTheme.foregroundColor!
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Column(
              spacing: 30.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icondata, size: 40.0),
                Text(tag, style: AppFonts.label20Of700),
              ],
            ),
          )
        ),
    );
  }
}