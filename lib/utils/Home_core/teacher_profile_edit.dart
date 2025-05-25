// utils/Home_core/teacher_profile_edit.dart
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smgi_teacher/utils/snack_bar/snack_bar.dart';

class TeacherProfileForm extends StatefulWidget {
  @override
  _TeacherProfileFormState createState() => _TeacherProfileFormState();
}

class _TeacherProfileFormState extends State<TeacherProfileForm> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  final _courseController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _photoUrlController = TextEditingController();
  final _uidController = TextEditingController();

  bool _obscurePassword = true;
  bool _alreadyUpdated = false;
  Map<String, dynamic> originalData = {};

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  Future<void> _loadExistingData() async {
    final doc = await firestore
        .collection('Teacher')
        .doc(auth.currentUser!.email)
        .get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _courseController.text = data['Course'] ?? '';
        _emailController.text = data['email'] ?? '';
        _nameController.text = data['name'] ?? '';
        _passwordController.text = data['password1'] ?? '';
        // _photoUrlController.text = data['photoUrl'] ?? '';
        // _uidController.text = data['uid'] ?? '';
        _alreadyUpdated = data['update'];
        originalData = data;
      });
    }
  }

  void _submitChanges() async {
    print(auth.currentUser!.email);
    final updates = <String, dynamic>{};

    if (_courseController.text != originalData['Course']) {
      updates['Course'] = _courseController.text;
    }
    if (_emailController.text != originalData['email']) {
      updates['email'] = _emailController.text;
    }
    if (_nameController.text != originalData['name']) {
      updates['name'] = _nameController.text;
    }
    if (_passwordController.text != originalData['password1']) {
      updates['password1'] = _passwordController.text;
    }
    // if (_photoUrlController.text != originalData['photoUrl']) {
    //   updates['photoUrl'] = _photoUrlController.text;
    // }

    if (updates.isEmpty) {
      snack_bar("No Changes", "No fields were changed.", context,
          ContentType.warning);
      return;
    }

    updates['update'] = true;

    try {
      await firestore
          .collection('Teacher') // 🔥 Fixed the typo here
          .doc(auth.currentUser!.email)
          .set(
              updates, SetOptions(merge: true)); // ✅ Merge: true keeps old data

      snack_bar("Success", "Profile updated successfully.", context,
          ContentType.success);
      setState(() {
        _alreadyUpdated = true;
      });
    } catch (e) {
      snack_bar("Error", "Failed to update profile: $e", context,
          ContentType.failure);
    }
  }

  @override
  void dispose() {
    _courseController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _photoUrlController.dispose();
    _uidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Teacher Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (_photoUrlController.text.isNotEmpty)
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(_photoUrlController.text),
              ),
            TextField(
              controller: _courseController,
              decoration: const InputDecoration(
                labelText: 'Course',
                hintText: 'e.g., BCA, MBA etc.',
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'e.g., abc@gmail.com',
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'e.g., John Doe',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            // TextField(
            //   controller: _photoUrlController,
            //   decoration: const InputDecoration(
            //     labelText: 'Photo URL (optional)',
            //   ),
            // ),
            // TextField(
            //   controller: _uidController,
            //   readOnly: true,
            //   decoration: const InputDecoration(
            //     labelText: 'UID (non-editable)',
            //   ),
            // ),
            const SizedBox(height: 20),
            !_alreadyUpdated
                ? ElevatedButton(
                    onPressed: _submitChanges,
                    child: const Text('Save Changes'),
                  )
                : Container(),
            const SizedBox(height: 20),
            !_alreadyUpdated
                ? const Text(
                    '⚠️ Be careful! Once updated, this information cannot be changed directly.\n'
                    'For any corrections, contact support@example.com',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  )
                : const Center(
                    child: Text(
                      '⚠️ You have already updated your profile.\nFor further changes, contact support@example.com',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
