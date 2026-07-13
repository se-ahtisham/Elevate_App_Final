import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  final double size;

  const ImageUpload({super.key, this.size = 90});

  @override
  State<ImageUpload> createState() => ImageUploadState();
}

class ImageUploadState extends State<ImageUpload> {
  final ImagePicker picker = ImagePicker();
  File? selectedImage;

  Future<void> pickImage() async {
    try {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => selectedImage = File(picked.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to pick image")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFECECEC),
          border: Border.all(color: Colors.black, width: 1.2),
          image: selectedImage != null
              ? DecorationImage(
                  image: FileImage(selectedImage!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: selectedImage == null
            ? const Icon(Icons.add, size: 32, color: Colors.black45)
            : null,
      ),
    );
  }
}
