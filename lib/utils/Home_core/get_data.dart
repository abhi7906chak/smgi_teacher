import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class UlpoadImage {
  Future<String> uploadImages(File image) async {
      final storge = FirebaseStorage.instance;
    String? imageUrl;
    String uid = const Uuid().v1();
    try {
      final storeref = storge.ref().child(uid);
      await storeref.putFile(image);
      // TaskSnapshot snapshot = await uploadtask;
      imageUrl = await storeref.getDownloadURL();
      // final imageUrl = storeref.getDownloadURL();
      debugPrint(imageUrl);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return imageUrl ?? " ";
  }
}
