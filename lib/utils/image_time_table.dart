// utils/image_time_table.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _fileUrl;
  String? _fileType; // "image" or "pdf"
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingFile();
  }

  Future<void> _loadExistingFile() async {
    final userEmail = _auth.currentUser?.email;
    if (userEmail == null) return;

    final doc = await _firestore.collection('Teacher').doc(userEmail).get();
    if (doc.exists) {
      setState(() {
        _fileUrl = doc['timetable'];
        _fileType = doc['fileType'];
      });
    }
  }

  Future<void> _showFilePickerDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Upload Image from Camera"),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndUploadImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Upload Image from Gallery"),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndUploadImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text("Upload PDF"),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndUploadPDF();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    if (pickedImage == null) return;

    setState(() => _loading = true);
    try {
      File imageFile = File(pickedImage.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("teacher_timetable/$fileName.jpg");
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      final userEmail = _auth.currentUser!.email;
      await _firestore.collection('Teacher').doc(userEmail).set({
        'timetable': downloadUrl,
        'fileType': 'image',
      }, SetOptions(merge: true));

      setState(() {
        _fileUrl = downloadUrl;
        _fileType = 'image';
      });

      print("Uploaded Image URL: $downloadUrl");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image uploaded successfully")),
      );
    } catch (e) {
      print("Upload error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error uploading image")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _pickAndUploadPDF() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result == null) return;

    setState(() => _loading = true);
    try {
      File file = File(result.files.single.path!);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("teacher_timetable/$fileName.pdf");
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      final userEmail = _auth.currentUser!.email;
      await _firestore.collection('Teacher').doc(userEmail).set({
        'timetable': downloadUrl,
        'fileType': 'pdf',
      }, SetOptions(merge: true));

      setState(() {
        _fileUrl = downloadUrl;
        _fileType = 'pdf';
      });

      print("Uploaded PDF URL: $downloadUrl");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PDF uploaded successfully")),
      );
    } catch (e) {
      print("Upload error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error uploading PDF")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  void _openFile() {
    if (_fileUrl == null) return;
    OpenFile.open(_fileUrl);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Upload Timetable")),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _showFilePickerDialog,
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload Image or PDF"),
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : _fileUrl == null
                      ? const Text("No file uploaded yet")
                      : _fileType == 'image'
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                _fileUrl!,
                                width: 180,
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              children: [
                                const Icon(Icons.picture_as_pdf,
                                    size: 80, color: Colors.red),
                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  onPressed: _openFile,
                                  icon: const Icon(Icons.download),
                                  label: const Text("Open PDF"),
                                )
                              ],
                            )
            ],
          ),
        ),
      ),
    );
  }
}
