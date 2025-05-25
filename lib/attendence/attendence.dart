// attendence/attendence.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TempAtten extends StatefulWidget {
  const TempAtten({
    super.key,
  });

  @override
  State<TempAtten> createState() => TempAttenState();
}

class TempAttenState extends State<TempAtten> {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final year = DateTime.now();
  var slecteddate = DateTime.now();
  var docDateFirebase = DateTime.now();
  DateTime? picked;

  slecttime() async {
    DateTime firstDate = DateTime(year.year, 1, 1);
    DateTime lastDate = DateTime(year.year, 4, 30);

    // Make sure initialDate is within the valid range
    DateTime initialDate = slecteddate;
    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    } else if (initialDate.isAfter(lastDate)) {
      initialDate = lastDate;
    }

    picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        slecteddate = picked!;
      });
      debugPrint('$picked');
    }
  }

  final DateFormat formater = DateFormat("dd/MM/yyyy");
  // String formatedDate = formater.format(picked!);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Row(
              children: [
                Text(
                  // ignore: prefer_interpolation_to_compose_strings
                  "Attendence",
                  style: TextStyle(
                      fontFamily: "Encode",
                      fontWeight: FontWeight.w400,
                      fontSize: 20),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await slecttime();
                      if (picked != null) {}
                    },
                    child: const Text("show date"),
                  ),
                  Text(formater.format(picked ?? DateTime.now()))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 300,
                width: double.infinity,
                child: StreamBuilder(
                  stream: firestore.collection('student').snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var studentData = snapshot.data!.docs[index].data();
                        var studentId = snapshot.data!.docs[index].data();
                        return Card(
                          child: ListTile(
                            leading: const CircleAvatar(),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () async {
                                    // Get the existing datesheets from Firestore
                                    DocumentSnapshot<Map<String, dynamic>>
                                        documentSnapshot = await firestore
                                            .collection("student")
                                            .doc(studentId["uid"])
                                            .collection("atten")
                                            .doc(
                                                docDateFirebase.year.toString())
                                            .get();

                                    if (documentSnapshot.exists) {
                                      // Remove the selected date from the existing datesheets
                                      Map<String, dynamic> existingDatesheets =
                                          documentSnapshot
                                                  .data()?['datesheets'] ??
                                              {};

                                      // Format the date consistently for removing
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(slecteddate);

                                      if (existingDatesheets
                                          .containsKey(formattedDate)) {
                                        existingDatesheets
                                            .remove(formattedDate);
                                        // Write the updated datesheets back to Firestore
                                        await firestore
                                            .collection("student")
                                            .doc(studentId["uid"])
                                            .collection("atten")
                                            .doc(
                                                docDateFirebase.year.toString())
                                            .update({
                                          "datesheets": existingDatesheets,
                                        }).then((value) {
                                          debugPrint("Date removed");
                                        });
                                      }
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.check),
                                  onPressed: () async {
                                    // Get the existing datesheets from Firestore
                                    DocumentSnapshot<Map<String, dynamic>>
                                        documentSnapshot = await firestore
                                            .collection("student")
                                            .doc(studentId["uid"])
                                            .collection("atten")
                                            .doc(
                                                docDateFirebase.year.toString())
                                            .get();

                                    Map<String, dynamic> existingDatesheets =
                                        documentSnapshot
                                                .data()?['datesheets'] ??
                                            {
                                              DateFormat('yyyy-MM-dd')
                                                  .format(slecteddate)
                                                  .toString(): 5
                                            };
                                    if (documentSnapshot.exists) {
                                      // Update the existing datesheets with the new entry
                                      if (picked == null) {
                                        existingDatesheets = {
                                          ...existingDatesheets,
                                          DateFormat('yyyy-MM-dd')
                                              .format(slecteddate)
                                              .toString(): 5
                                        };
                                      } else {
                                        existingDatesheets = {
                                          ...existingDatesheets,
                                          DateFormat('yyyy-MM-dd')
                                              .format(slecteddate)
                                              .toString(): 5
                                        };
                                      }

                                      // Write the updated datesheets back to Firestore
                                      await firestore
                                          .collection("student")
                                          .doc(studentId["uid"])
                                          .collection("atten")
                                          .doc(docDateFirebase.year.toString())
                                          .update({
                                        "datesheets": existingDatesheets
                                      }).then((value) {
                                        debugPrint("check");
                                      });
                                    } else {
                                      if (kDebugMode) {
                                        print("Not exists");
                                      }
                                      await firestore
                                          .collection("student")
                                          .doc(studentId["uid"])
                                          .collection("atten")
                                          .doc(docDateFirebase.year.toString())
                                          .set({
                                        "datesheets": existingDatesheets
                                      }).then((value) {
                                        if (kDebugMode) {
                                          print("now check");
                                        }
                                      });
                                    }
                                  },
                                )
                              ],
                            ),
                            title: Text(studentData['name']),
                            subtitle: Text(studentData['email']),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
