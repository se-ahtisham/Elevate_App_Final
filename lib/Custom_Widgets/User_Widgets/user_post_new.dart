import 'dart:io';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description_short.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class UserPostNew extends StatelessWidget {
  final String hintTitle;
  final String hintText;
  final String imageURL;
  final String name;
  final String shortDescription;
  final TextEditingController titleController;
  final TextEditingController shortDescriptionController;
  final VoidCallback? onPost;
  final VoidCallback? onPickImage;
  final File? selectedImageFile;
  final VoidCallback? onRemoveImage;
  final Color borderColor;
  final int borderSize;

  const UserPostNew({
    super.key,
    required this.hintTitle,
    required this.hintText,
    required this.imageURL,
    required this.name,
    this.shortDescription = "",
    required this.titleController,
    required this.shortDescriptionController,
    this.onPost,
    this.onPickImage,
    this.selectedImageFile,
    this.onRemoveImage,
    this.borderColor = ElevateColor.gray,
    this.borderSize = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: ElevateColor.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: borderSize.toDouble()),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserDescriptionShort(
                imageURL: imageURL,
                name: name,
                shortDescription: shortDescription,
              ),

              const SizedBox(height: 20),

              CustomTextField(
                controller: titleController,
                hintText: hintTitle,
                cursorColor: ElevateColor.lightgray,
                underlineColor: ElevateColor.lightgray,
                textColor: Colors.black,
              ),

              const SizedBox(height: 20),

              CustomTextField(
                controller: shortDescriptionController,
                hintText: hintText,
                cursorColor: ElevateColor.lightgray,
                underlineColor: ElevateColor.lightgray,
                textColor: Colors.black,
              ),

              const SizedBox(height: 20),

              if (onPickImage != null) ...[
                // Attachment Action Row (< 100 KB)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Attach Photo (< 100KB)",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                      onPressed: onPickImage,
                    ),
                  ],
                ),

                if (selectedImageFile != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            selectedImageFile!,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            onTap: onRemoveImage,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],

              TextButtonGradient(text: "POST NOW", onTap: onPost),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
