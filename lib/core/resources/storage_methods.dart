import 'dart:typed_data';
import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';


class StorageMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Cloudinary cloudinary = Cloudinary.signedConfig(
    cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME']!,
    apiKey: dotenv.env['CLOUDINARY_API_KEY']!,
    apiSecret: dotenv.env['CLOUDINARY_API_SECRET']!
  );


  
  Future<void> deleteProfileImageFromCloudinary(String imageUrl) async {
    try {
      // Strip query parameters (like ?v=123456)
      final urlWithoutQuery = imageUrl.split('?').first;
      // print("URL without query: " + urlWithoutQuery);

      // Extract public_id from URL
      final uri = Uri.parse(urlWithoutQuery);
      final segments = uri.pathSegments;
      final uploadIndex = segments.indexOf('upload');
      // print("UPLOAD INDEX: " + uploadIndex.toString());
      if (uploadIndex == -1) throw Exception("Invalid Cloudinary URL");


      // public_id = everything after 'upload/' minus file extension
      final pathAfterUpload = segments.sublist(uploadIndex + 2).join('/');
      // print("PATH AFTER UPLOAD: " + pathAfterUpload);
      final publicId = pathAfterUpload.split('.').first;
      
      print("-----------------------------------");
      print("Deleting Cloudinary image with publicId: $publicId");
      print("-----------------------------------");

      // Call Cloudinary destroy
      final response = await cloudinary.destroy(
        publicId,
        // url: imageUrl,
        resourceType: CloudinaryResourceType.image,
        invalidate: true, // optional: forces cache invalidation
      );

      if (response.isSuccessful) {
        print('Profile image deleted: $publicId');
      } else {
        print('Failed to delete image: ${response.error}');
        print('Failed to delete image: ${response.result}');
      }
    } catch (e) {
      print('Error deleting image from Cloudinary: $e');
    }
  }

  
  Future<String?> uploadImageToCloudinary({
     required Uint8List image, 
     required bool isPost, 
     String? fileName,
    }) async{
    try{
      // authenticating user
      final user = auth.currentUser;
      if (user == null) {
        print("No authenticated user found");
        return null;
      }

      final folder = isPost 
        ? 'postily/posts/${user.uid}' 
        : 'postily/profilePics';

      final fileName = isPost 
        ? Uuid().v1() 
        : user.uid ;

      // uploading to cloudinary
      final response = await cloudinary.unsignedUpload(
        uploadPreset: 'ccwcyukj',
        fileBytes: image,
        resourceType: CloudinaryResourceType.image,
        folder: folder,
        fileName: fileName,
        progressCallback: (count, total) {
          // print( 'Uploading progress: $count/$total' );
        }
      );

      if(response.isSuccessful) {
        print('Get your image from ${response.secureUrl}');
        return "${response.secureUrl}?v=${DateTime.now().millisecondsSinceEpoch}";
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