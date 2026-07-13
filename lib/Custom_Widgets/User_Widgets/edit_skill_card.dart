import "package:elevate_app/Custom_Widgets/Image/image_upload.dart";
import "package:flutter/material.dart";

class EditSkillCard extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final VoidCallback onUpdateTap;
  final VoidCallback onCancelTap;

  const EditSkillCard({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.onUpdateTap,
    required this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(child: ImageUpload(size: 100)),
        const SizedBox(height: 30),
        field("Skill Title", titleController),
        const SizedBox(height: 24),
        field("Skill Description", descriptionController),
        const SizedBox(height: 40),

        // Update Skill button
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: onUpdateTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Update Skill",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Cancel button
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: onCancelTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black, width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget field(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            isDense: true,
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black26),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black26),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
