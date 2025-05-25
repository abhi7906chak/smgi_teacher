// attendence/attendence.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    DateTime lastDate = DateTime(year.year, 12, 31);

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
                                    DocumentSnapshot<Map<String, dynamic>>
                                        documentSnapshot = await firestore
                                            .collection("student")
                                            .doc(studentId["email"])
                                            .collection("atten")
                                            .doc(
                                                docDateFirebase.year.toString())
                                            .get();

                                    if (documentSnapshot.exists) {
                                      Map<String, dynamic> existingDatesheets =
                                          documentSnapshot
                                                  .data()?['datesheets'] ??
                                              {};

                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(slecteddate);

                                      if (existingDatesheets
                                          .containsKey(formattedDate)) {
                                        existingDatesheets
                                            .remove(formattedDate);

                                        await firestore
                                            .collection("student")
                                            .doc(studentId["email"])
                                            .collection("atten")
                                            .doc(
                                                docDateFirebase.year.toString())
                                            .update({
                                          "datesheets": existingDatesheets,
                                        }).then((value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "Attendance removed for ${studentData['name']}")),
                                          );
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
                                    DocumentSnapshot<Map<String, dynamic>>
                                        documentSnapshot = await firestore
                                            .collection("student")
                                            .doc(studentId["email"])
                                            .collection("atten")
                                            .doc(
                                                docDateFirebase.year.toString())
                                            .get();

                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(slecteddate);
                                    Map<String, dynamic> existingDatesheets =
                                        documentSnapshot
                                                .data()?['datesheets'] ??
                                            {};

                                    existingDatesheets = {
                                      ...existingDatesheets,
                                      formattedDate: 5
                                    };

                                    if (documentSnapshot.exists) {
                                      await firestore
                                          .collection("student")
                                          .doc(studentId["email"])
                                          .collection("atten")
                                          .doc(docDateFirebase.year.toString())
                                          .update({
                                        "datesheets": existingDatesheets
                                      }).then((value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Attendance marked for ${studentData['name']}")),
                                        );
                                      });
                                    } else {
                                      await firestore
                                          .collection("student")
                                          .doc(studentId["email"])
                                          .collection("atten")
                                          .doc(docDateFirebase.year.toString())
                                          .set({
                                        "datesheets": existingDatesheets
                                      }).then((value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Attendance created for ${studentData['name']}")),
                                        );
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
