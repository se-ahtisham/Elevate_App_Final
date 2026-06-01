import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description_short.dart';
import 'package:flutter/material.dart';

class AdminCommentTile extends StatelessWidget {
  final String title;
  final String text;

  final String imageURL;
  final String name;
  final String shortDescription;

  final VoidCallback? onTap;

  const AdminCommentTile({
    super.key,
    required this.title,
    required this.text,
    required this.imageURL,
    required this.name,
    required this.shortDescription,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 231, 231, 231),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromARGB(255, 143, 143, 143)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserDescriptionShort(
            imageURL: imageURL,
            name: name,
            shortDescription: shortDescription,
          ),

          const SizedBox(height: 16),
          CustomText(text: title, fontSize: 14),
          const SizedBox(height: 12),

          CustomText(text: text, fontSize: 14, color: Colors.black87),
          SizedBox(height: 20),
          TextButtonGradient(
            text: "Delete Comment",
            height: 50,
            borderRadius: 25,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
