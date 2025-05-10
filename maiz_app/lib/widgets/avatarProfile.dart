import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AvatarProfile extends StatefulWidget {
  const AvatarProfile({super.key});

  @override
  State<AvatarProfile> createState() => _AvatarProfileState();
}

class _AvatarProfileState extends State<AvatarProfile> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? imagePath = prefs.getString('avatar_image');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  Future<void> _saveImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatar_image', imagePath);
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, // Calidad reducida para optimización
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _saveImage(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          children: [
            ClipOval(
              child: Container(
                alignment: Alignment.center,
                color: Colors.deepPurple,
                child: _image == null
                    ? const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      )
                    : Image.file(
                        _image!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            // Ícono de lápiz en la esquina inferior derecha
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit,
                  size: 20,
                  color:  Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
