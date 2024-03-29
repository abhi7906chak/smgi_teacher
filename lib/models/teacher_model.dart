// ignore_for_file: camel_case_types, non_constant_identifier_names, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: duplicate_ignore, duplicate_ignore
class teacher {
  final String name;
  final String uid;
  final String photourl;
  final String email;
  final String password;
  // ignore: non_constant_identifier_names
  final String Course;
  // final Map<String, int>? datesheet; // Use String keys
  // final DateTime? date;

  teacher({
    // this.date,
    // this.datesheet,
    required this.Course,
    required this.password,
    required this.name,
    required this.uid,
    required this.photourl,
    required this.email,
  });

  static teacher fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return teacher(
      Course: snapshot["Course"],
      // datesheet: snapshot['datesheet'],
      name: snapshot["name"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      password: snapshot['password1'],
      photourl: snapshot['photourl'],
    );
  }

  Map<String, dynamic> toJson() => {
        // "datesheet": datesheet,
        "name": name,
        "uid": uid,
        "email": email,
        "photourl": photourl,
        "Course": Course,
        "password1": password
      };
}
