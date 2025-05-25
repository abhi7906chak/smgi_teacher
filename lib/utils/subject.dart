// utils/subject.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeacherSubjectManager extends StatefulWidget {
  final String teacherId; // teacher's document id in firestore

  const TeacherSubjectManager({super.key, required this.teacherId});

  @override
  State<TeacherSubjectManager> createState() => _TeacherSubjectManagerState();
}

class _TeacherSubjectManagerState extends State<TeacherSubjectManager> {
  final TextEditingController _subjectController = TextEditingController();
  bool _isAdding = false;

  Future<void> _addSubject() async {
    final newSubject = _subjectController.text.trim();
    if (newSubject.isEmpty) return;

    setState(() {
      _isAdding = true;
    });

    final docRef =
        FirebaseFirestore.instance.collection('Teacher').doc(widget.teacherId);

    try {
      await docRef.update({
        'subjects': FieldValue.arrayUnion([newSubject]),
      });
      _subjectController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add subject: $e')),
      );
    } finally {
      setState(() {
        _isAdding = false;
      });
    }
  }

  Future<void> _removeSubject(String subject) async {
    final docRef =
        FirebaseFirestore.instance.collection('Teacher').doc(widget.teacherId);

    try {
      await docRef.update({
        'subjects': FieldValue.arrayRemove([subject]),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove subject: $e')),
      );
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final docRef =
        FirebaseFirestore.instance.collection('Teacher').doc(widget.teacherId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Subjects"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Input row for adding new subject
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _subjectController,
                    decoration: InputDecoration(
                      labelText: 'Add New Subject',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (_) => _addSubject(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                    onPressed: _isAdding ? null : _addSubject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isAdding
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Add',
                            style: TextStyle(color: Colors.white),
                          ))
              ],
            ),

            const SizedBox(height: 20),

            // Subject list from firestore
            StreamBuilder<DocumentSnapshot>(
              stream: docRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('No data found'));
                }

                final data = snapshot.data!.data() as Map<String, dynamic>?;

                final List<dynamic> subjects = data?['subjects'] ?? [];

                if (subjects.isEmpty) {
                  return const Center(child: Text('No subjects added yet.'));
                }

                return Expanded(
                  child: ListView.separated(
                    itemCount: subjects.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final subject = subjects[index].toString();
                      return ListTile(
                        title:
                            Text(subject, style: const TextStyle(fontSize: 18)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeSubject(subject),
                          tooltip: 'Remove Subject',
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
