import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UlpoadImage {
  Future<String> uploadImages(File image) async {
    String imageUrl = "";
    String uid = Uuid().v1();
    try {
      final storge = FirebaseStorage.instance;
      final storeref = storge.ref().child(uid);
      await storeref.putFile(image);
      // TaskSnapshot snapshot = await uploadtask;
      imageUrl = await storeref.getDownloadURL();
      // final imageUrl = storeref.getDownloadURL();
      debugPrint(imageUrl);
    } catch (e) {
      print(e.toString());
    }
    return imageUrl;
  }
}
