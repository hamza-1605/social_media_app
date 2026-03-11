import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/core/constants/links.dart';
import 'package:social_media_app/core/providers/user_provider.dart';
import 'package:social_media_app/core/resources/firestore_methods.dart';
import 'package:social_media_app/core/utils/utils.dart';
import 'package:social_media_app/screens/authentication/widgets/custom_text_box.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bioController = TextEditingController();
  final firstNameNode = FocusNode(); 
  final lastNameNode = FocusNode(); 
  final bioNode = FocusNode(); 

  bool isLoading = false;
  bool removeImage = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final user = context.read<UserProvider>().getUser!;

    firstNameController.text = user.firstname;
    lastNameController.text = user.lastname;
    bioController.text = user.bio ?? "";
    image = user.photoUrl; 
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    bioController.dispose();
    firstNameNode.dispose();
    lastNameNode.dispose();
    bioNode.dispose();
    super.dispose();
  }

  late String? image;
  Uint8List? newImage;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            
            /// Profile Image
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: removeImage
                    ? CachedNetworkImageProvider(Links().genericUser)
                    : newImage != null
                        ? MemoryImage(newImage!)
                        : CachedNetworkImageProvider(
                            image ?? Links().genericUser,
                          ),
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () => selectImage(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.logoColor,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 10),

            if (image != null || newImage != null)
              TextButton(
                onPressed: () {
                  setState(() {
                    newImage = null;
                    removeImage = true;
                  });
                },
                child: const Text(
                  "Remove photo",
                  style: TextStyle(color: Colors.red),
                ),
              ),

            const SizedBox(height: 30),

            /// First Name
            CustomTextBox(
              controller: firstNameController,
              label: "First Name",
              node: firstNameNode,
              submit: () => FocusScope.of(context).requestFocus(lastNameNode),
            ),

            const SizedBox(height: 15),

            /// Last Name
            CustomTextBox(
              controller: lastNameController,
              label: "Last Name",
              node: lastNameNode,
              submit: () => FocusScope.of(context).requestFocus(bioNode),
            ),

            const SizedBox(height: 15),

            /// Bio
            CustomTextBox(
              controller: bioController,
              label: "Bio",
              node: bioNode,
              submit: () => FocusScope.of(context).unfocus(),
            ),

            const SizedBox(height: 30),

            /// Save Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isLoading ? null : saveProfile,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> saveProfile() async {
    final user = context.read<UserProvider>().getUser!;

    setState(() {
      isLoading = true;
    });

    await FirestoreMethods().updateProfile(
      userid: user.userid,
      firstname: firstNameController.text.trim(),
      lastname: lastNameController.text.trim(),
      bio: bioController.text.trim(),
      file: newImage,
      removeImage: removeImage
    );

    if (!mounted) return;
    await context.read<UserProvider>().refreshUser();

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;
    Navigator.pop(context);
  }


  void selectImage() async{ 
    Uint8List? img = await selectImageOptions(context);
    setState(() {
      if(img != null){
        newImage = img;
        removeImage = false; 
      }   
    });
  }
}