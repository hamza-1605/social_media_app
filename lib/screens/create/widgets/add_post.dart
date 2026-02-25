import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key, required this.textOnly, this.image});
  
  final bool textOnly;
  final String? image; 

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: widget.textOnly ? const Text("New Thought") : const Text("New Post"),
          centerTitle: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(Icons.arrow_back)
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20.0,
              children: [
                
                !widget.textOnly 
                ? Container(
                  decoration: BoxDecoration(
                    border: BoxBorder.all(width: 1.0, color: AppColors.middlewareGrey),
                    borderRadius: BorderRadius.circular(12.0)                        
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      alignment: AlignmentGeometry.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(12.0),
                          child: Image.network(
                            widget.image!,
                            fit: BoxFit.contain,
                          ),
                        ),
                  
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton.filled(
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.buttonBlue,
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.replay),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : SizedBox(),
                
                SizedBox(
                  child: TextField(
                    onChanged: (value) => setState(() {}),
                    controller: textController,
                    decoration: InputDecoration( 
                      border: UnderlineInputBorder(),
                      hintText: widget.textOnly ? "Write your thoughts..." : "Add a caption..."
                    ),
                    minLines: 1,
                    maxLines: 8,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: FilledButton(
                    onPressed: 
                      widget.textOnly ? 
                        textController.text.trim().isEmpty 
                        ? null : (){
                          // text post operation
                        }
                        : (){
                          // image + caption operation
                        }, 
                    child: Text("POST")
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}