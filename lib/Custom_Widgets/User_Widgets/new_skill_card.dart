import 'package:elevate_app/Custom_Widgets/Image/image_upload.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:flutter/material.dart';

class NewSkillCard extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final VoidCallback onCreateTap;

  const NewSkillCard({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.onCreateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ImageUpload(),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: titleController,
                      hintText: "Skill Title",
                      textColor: Colors.white,
                      cursorColor: Colors.white,
                      underlineColor: Colors.white38,
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      controller: descriptionController,
                      hintText: "Skill Description",
                      textColor: Colors.white,
                      cursorColor: Colors.white,
                      underlineColor: Colors.white38,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onCreateTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: const Text(
                "CREATE NOW",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
