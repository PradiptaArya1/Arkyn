import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadGameScreen extends StatefulWidget {
  const UploadGameScreen({super.key});

  @override
  _UploadGameScreenState createState() => _UploadGameScreenState();
}

class _UploadGameScreenState extends State<UploadGameScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  File? _gamePictureFile;
  bool _isUploading = false;

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _gamePictureFile = File(pickedFile.path);
      });
    }
  }

  // Fungsi untuk mengunggah data game ke Firebase
  Future<void> _uploadData() async {
    if (_nameController.text.isEmpty ||
        _categoryController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _aboutController.text.isEmpty ||
        _gamePictureFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Unggah gambar ke Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('game_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = await storageRef.putFile(_gamePictureFile!);
      final imageUrl = await uploadTask.ref.getDownloadURL();

      // Unggah data ke Firestore
      final gamesCollection = FirebaseFirestore.instance.collection('games');
      await gamesCollection.add({
        'name': _nameController.text,
        'category': _categoryController.text,
        'price': double.parse(_priceController.text),
        'about': _aboutController.text,
        'image_url': imageUrl,
        'uploaded_at': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Game uploaded successfully')),
      );

      // Reset form
      _nameController.clear();
      _categoryController.clear();
      _priceController.clear();
      _aboutController.clear();
      setState(() {
        _gamePictureFile = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text(
          'Upload Game',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input fields
            ...[
              {'label': 'Name', 'controller': _nameController},
              {'label': 'Category', 'controller': _categoryController},
              {'label': 'Price', 'controller': _priceController},
              {'label': 'About', 'controller': _aboutController},
            ].map((field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field['label'] as String,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: field['controller'] as TextEditingController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1F2937),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Enter ${field['label']}',
                      hintStyle: const TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }),
            const Text(
              'Game Picture',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF374151),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _gamePictureFile == null
                    ? const Icon(Icons.add, color: Colors.white)
                    : Image.file(
                        _gamePictureFile!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const Spacer(),
            if (_isUploading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: _uploadData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                    ),
                    child: const Text('Upload',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
