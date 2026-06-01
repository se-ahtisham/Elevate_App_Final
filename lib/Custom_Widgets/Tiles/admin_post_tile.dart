import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description_short.dart';
import 'package:flutter/material.dart';

class AdminPostTile extends StatelessWidget {
  final String timed;
  final String title;
  final String text;
  final int commentCount;
  final List<String> comments;

  final String imageURL;
  final String name;
  final String shortDescription;

  final VoidCallback? deleteonTap;
  final VoidCallback? viewCommentonTap;

  const AdminPostTile({
    super.key,
    this.timed = "Just now",
    required this.title,
    required this.text,
    required this.commentCount,
    required this.comments,
    required this.imageURL,
    required this.name,
    required this.shortDescription,
    this.deleteonTap,
    this.viewCommentonTap,
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
          Row(
            children: [
              Expanded(
                child: UserDescriptionShort(
                  imageURL: imageURL,
                  name: name,
                  shortDescription: shortDescription,
                ),
              ),
              CustomText(text: timed, fontSize: 10.5, color: Colors.grey),
            ],
          ),

          const SizedBox(height: 16),

          CustomText(text: title, fontSize: 14),

          const SizedBox(height: 12),

          CustomText(text: text, fontSize: 14, color: Colors.black87),

          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.chat_bubble_outline, size: 25),
              const SizedBox(width: 6),
              CustomText(text: "$commentCount", fontSize: 14),
              const SizedBox(width: 40),
              Expanded(
                child: TexxtButton(
                  text: "View all comments",
                  textSize: 13,
                  textColor: Colors.black87,
                  backgroundColor: const Color(0xFFE5E7EB),
                  borderRadius: 20,
                  borderColor: Colors.black,
                  borderWidth: 1,
                  height: 40,
                  onTap: viewCommentonTap,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          TextButtonGradient(
            text: "Delete Post",
            height: 50,
            borderRadius: 25,
            onTap: deleteonTap,
          ),
        ],
      ),
    );
  }
}
