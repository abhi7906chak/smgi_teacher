// utils/image_upload.dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageUploader {
  final ImagePicker _picker = ImagePicker();

  /// Picks an image from gallery and uploads to Firebase Storage.
  Future<String?> pickAndUploadImage(BuildContext context) async {
    try {
      // Step 1: Pick image from gallery
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image not selected.')),
        );
        return null;
      }

      File imageFile = File(image.path);

      // Step 2: Upload image to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName.jpg');

      UploadTask uploadTask = storageRef.putFile(imageFile);

      TaskSnapshot snapshot = await uploadTask;

      // Step 3: Get download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image')),
      );
      return null;
    }
  }
}
