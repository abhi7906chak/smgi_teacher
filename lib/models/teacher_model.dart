// models/teacher_model.dart
// ignore_for_file: camel_case_types, non_constant_identifier_names, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: duplicate_ignore, duplicate_ignore
class teacher {
  final String name;
  final String uid;
  final String photourl;
  final String email;
  final String password;
  final bool update;
  final String Course;
  final String timetable; // ✅ new field
  final List<String> subjects; // ✅ new field

  teacher({
    required this.update,
    required this.Course,
    required this.password,
    required this.name,
    required this.uid,
    required this.photourl,
    required this.email,
    required this.timetable,
    required this.subjects,
  });

  static teacher fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return teacher(
      Course: snapshot["Course"],
      update: snapshot["update"],
      name: snapshot["name"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      password: snapshot['password1'],
      photourl: snapshot['photourl'],
      timetable: snapshot["timetable"] ?? "",
      subjects: List<String>.from(snapshot["subjects"] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "uid": uid,
        "email": email,
        "photourl": photourl,
        "Course": Course,
        "password1": password,
        "update": update,
        "timetable": timetable,
        "subjects": subjects,
      };
}
