// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: camel_case_types
class post {
  final String title;
  final String uid;
  final String postId;
  // ignore: prefer_typing_uninitialized_variables
  final like;
  final DateTime date;
  final String photoUrl;
  post({
    required this.like,
    required this.title,
    required this.uid,
    required this.postId,
    required this.date,
    required this.photoUrl,
  });

  static post fromsnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return post(
      like: snapshot["like"],
        title: snapshot["title"],
        uid: snap["uid"],
        postId: snapshot["postId"],
        date: snapshot["date"],
        photoUrl: snapshot["photoUrl"]);
  }

  Map<String, dynamic> tojson() => {
    "like": like,
    "title": title,
    "uid": uid,
    "postId": postId,
    "date": date,
    "photoUrl": photoUrl,
  };
}
