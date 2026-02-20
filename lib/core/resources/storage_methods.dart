import 'dart:typed_data';
import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StorageMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Cloudinary cloudinary = Cloudinary.unsignedConfig(
    cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME']!
  );


  Future<String?> uploadImageToCloudinary(String folder, Uint8List image, bool isPost) async{
    try{
      // authentiacating user
      final user = auth.currentUser;
      if (user == null) {
        print("No authenticated user found");
        return null;
      }

      // uploading to cloudinary
      final response = await cloudinary.unsignedUpload(
        uploadPreset: 'ccwcyukj',
        fileBytes: image,
        resourceType: CloudinaryResourceType.image,
        folder: 'postily/users/${auth.currentUser!.uid}/$folder',
        fileName: 'profile_${DateTime.now().millisecondsSinceEpoch}',
        progressCallback: (count, total) {
          print( 'Uploading progress: $count/$total' );
        }
      );

      if(response.isSuccessful) {
        print('Get your image from with ${response.secureUrl}');
        return response.secureUrl;
      } else {
        print("Upload failed: ${response.error}");
        return null;
      }
    }
    catch (e){
      print(e.toString());
      return null;
    }
  }
}