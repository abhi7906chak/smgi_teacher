// utils/account_validate_src.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentApprovalScreen extends StatelessWidget {
  const StudentApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Student Approvals"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('student')
            .where('status', isEqualTo: 'pending' )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No pending requests.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final students = snapshot.data!.docs;

          return Column(
            children: [
              Expanded(
                // <-- Isko wrap kar diya ListView ke around
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: students.length + 1,
                  itemBuilder: (context, index) {
                    if (index == students.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12),
                        child: Text(
                          "Once you have rejected or approved, you cannot make any further changes.\n\n"
                          "For support, please contact us via system@gmail.com.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    final student = students[index];
                    final name = student['name'] ?? 'No Name';
                    final email = student['email'] ?? 'No Email';
                    final photoUrl = student['photourl'];
                    final uid = student.id;

                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.deepPurple.shade100,
                          backgroundImage:
                              photoUrl != null ? NetworkImage(photoUrl) : null,
                          child: photoUrl == null
                              ? const Icon(Icons.person,
                                  size: 28, color: Colors.white)
                              : null,
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          email,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check_circle,
                                  color: Colors.green),
                              tooltip: 'Approve',
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('student')
                                    .doc(uid)
                                    .update({'status': 'approved'});
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              tooltip: 'Reject',
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('student')
                                    .doc(uid)
                                    .update({'status': 'rejected'});
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
