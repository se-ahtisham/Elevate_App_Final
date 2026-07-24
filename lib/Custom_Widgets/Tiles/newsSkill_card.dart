import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Skills/admin_manage_topics.dart';
import 'package:flutter/material.dart';

class NewSkillCard extends StatelessWidget {
  final String? imagePath; // bare asset filename, e.g. "flutter.png"
  final VoidCallback onPickImage;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final VoidCallback onCreateTap;

  const NewSkillCard({
    super.key,
    required this.imagePath,
    required this.onPickImage,
    required this.titleController,
    required this.descriptionController,
    required this.onCreateTap,
  });

  Widget _labeledField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: CustomTextField(
              hintText: hint,
              controller: controller,
              cursorColor: Colors.white,
              underlineColor: Colors.transparent,
              textColor: Colors.white,
              hintColor: const Color.fromARGB(255, 121, 121, 121),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // The single image placeholder for this card.
          GestureDetector(
            onTap: onPickImage,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              backgroundImage: imagePath != null && imagePath!.isNotEmpty
                  ? AssetImage("lib/Resources/Images/Skills/$imagePath")
                        as ImageProvider
                  : null,
              child: imagePath == null || imagePath!.isEmpty
                  ? const Icon(Icons.add, color: Colors.black, size: 30)
                  : null,
            ),
          ),

          const SizedBox(height: 25),

          _labeledField(
            label: "Skill Name",
            hint: "Flutter Development",
            controller: titleController,
          ),

          const SizedBox(height: 20),

          _labeledField(
            label: "Description",
            hint: "Short description of this skill",
            controller: descriptionController,
          ),

          const SizedBox(height: 25),

          // NEW: Manage Topics button — lets admin set up the topic pool
          // using whatever skill name is currently typed above, before
          // or after actually creating the skill.
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                final skillName = titleController.text.trim();
                if (skillName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Type a skill name first')),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AdminManageTopics(skillName: skillName),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white, width: 1),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const CustomText(
                text: "MANAGE TOPICS",
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onCreateTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const CustomText(
                text: "CREATE NOW",
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
