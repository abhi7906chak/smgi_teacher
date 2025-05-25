// utils/single_stu_data.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentDetailScreen extends StatelessWidget {
  final String uid; // Document ID of student

  const StudentDetailScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.deepPurple;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Student Detail"),
        centerTitle: true,
        backgroundColor: themeColor,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('student').doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Student data not found"));
          }

          final student = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Image
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: themeColor.withOpacity(0.1),
                    backgroundImage: student['photourl'] != null
                        ? NetworkImage(student['photourl'])
                        : null,
                    child: student['photourl'] == null
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  student['name'] ?? '',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  student['email'] ?? '',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Info Box
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    children: [
                      buildDetailRow(
                          Icons.badge, "Roll Number", student['rollnum']),
                      buildDetailRow(Icons.credit_card, "Aadhar Number",
                          student['aadharnum']),
                      buildDetailRow(
                          Icons.perm_identity, "ABC ID", student['abcid']),
                      buildDetailRow(Icons.phone, "Phone", student['phonenum']),
                      buildDetailRow(
                          Icons.man, "Father's Name", student['fathername']),
                      buildDetailRow(
                          Icons.woman, "Mother's Name", student['mothername']),
                      buildDetailRow(
                          Icons.verified_user, "UID", student['uid']),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildDetailRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value != null && value.isNotEmpty ? value : 'N/A',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
