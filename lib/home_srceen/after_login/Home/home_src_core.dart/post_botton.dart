import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smgi_teacher/models/post_model.dart';
import 'package:smgi_teacher/utils/Home_core/get_data.dart';
import 'package:smgi_teacher/utils/snack_bar/snack_bar.dart';
import 'package:uuid/uuid.dart';

class PostBotton {
  final firestore = FirebaseFirestore.instance;
  String? imageUrl;
  final auth = FirebaseAuth.instance;

  Future<void> postbutton(BuildContext context, TextEditingController notiTitle,
      File? image) async {
    String title = notiTitle.text.trim();
    if (kDebugMode) {
      print("pressed");
    }
    if (image != null) {
      imageUrl = await UlpoadImage().uploadImages(image);
    } else {
      imageUrl = "";
    }

    String uid = const Uuid().v1();
    var Post = post(
        like: 1,
        title: title,
        uid: auth.currentUser!.uid,
        postId: uid,
        date: DateTime.now(),
        photoUrl: imageUrl!);

    try {
      if (title.isNotEmpty || imageUrl!.isNotEmpty) {
        await firestore
            .collection("Teacher")
            .doc(auth.currentUser!.email.toString())
            .collection("Post")
            .doc(uid)
            .set(Post.tojson())
            .then((value) {
          snack_bar(
              "Posted", "Posing succsesfull", context, ContentType.success);
        });
      } else {
        snack_bar("No Data", "Not have any data to post", context,
            ContentType.warning);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      snack_bar("Error", e.toString(), context, ContentType.failure);
    }
  }
}
