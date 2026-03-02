import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/providers/user_provider.dart';
import 'package:social_media_app/core/resources/firestore_methods.dart';
import 'package:social_media_app/core/utils/utils.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key, required this.image});
  
  final Uint8List? image;

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController textController = TextEditingController();
  late Uint8List? selectedImage;
  bool isLoading = false;

  void uploadPost({
    Uint8List? image,
    required String userid,
    required String firstname,
    required String lastname,
    required String? profileUrl,
    required String email,
  }) async{
    try {
      setState(() {
        isLoading = true;
      });
      String res = await FirestoreMethods().uploadPost(
        image: selectedImage, 
        userid: userid, 
        caption: textController.text.trim(), 
        firstname: firstname, 
        lastname: lastname, 
        email: email,
        profileUrl: profileUrl,
      );
      print(res);
      if(!mounted) return;
      if(res == "success"){
        print("res ----- Success");
        showSnackBar(context, "Post Uploaded!");
        Navigator.pop(context);
      } else{
        showSnackBar(context, res);
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }


  @override
  void initState() {
    super.initState();
    selectedImage = widget.image;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);
    if (!userProv.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    
    final user = userProv.user;
    
    final caption = textController.text.trim();
    final isTextPost = selectedImage == null;
    final isDisabled = isTextPost && caption.isEmpty;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: selectedImage == null ? const Text("New Thought") : const Text("New Post"),
          centerTitle: false,
          forceMaterialTransparency: true,
          leading: IconButton(
            onPressed: () {
              // DISCARD POST
              if(selectedImage != null  ||  textController.text.isNotEmpty){
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: Text("Do you want to discard your post?"),
                    actions: [
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        }, 
                        child: Text("No, wait")
                      ),
                      
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }, 
                        child: Text("Discard")
                      ),
                    ],
                  );
                },);
              }
              else{
                Navigator.pop(context);
              }
            }, 
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
                
                // show container if there is image
                selectedImage != null
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
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: MemoryImage(selectedImage!),
                                fit: BoxFit.contain
                              ),
                            ),
                          ),
                        ),
                  
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton.filled(
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.buttonBlue,
                            ),
                            onPressed: () => reselectImage(),
                            icon: const Icon(Icons.replay),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : SizedBox.shrink(),
                
                // Caption/Text Area
                SizedBox(
                  child: TextField(
                    onChanged: (value) => setState(() {}),
                    controller: textController,
                    decoration: InputDecoration( 
                      border: UnderlineInputBorder(),
                      hintText: selectedImage == null ? "Write your thoughts..." : "Add a caption..."
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny( RegExp(r'\n{3,}') ),
                    ],
                    minLines: 1,
                    maxLines: 8,
                    maxLength: 500,
                  ),
                ),

                // Submit Button
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: FilledButton(
                    onPressed: isDisabled || isLoading
                      ? null
                      : () {
                        FocusScope.of(context).unfocus();
                        uploadPost(
                          image: selectedImage,
                          userid: user.userid,
                          firstname: user.firstname,
                          lastname: user.lastname,
                          profileUrl: user.photoUrl,
                          email: user.email,
                        );
                    }, 
                    child: isLoading ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator()
                    ) : Text("POST")
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  void reselectImage() async{

    Uint8List? newImage = await selectImageOptions(context);

    if (newImage != null) {
      setState(() {
        selectedImage = newImage;
      });
    }
  }

}