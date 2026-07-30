import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
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

  String get _initial =>
      name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : "?";

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
              // Black circle avatar with the person's first initial
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  _initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: name,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    CustomText(
                      text: shortDescription,
                      fontSize: 12,
                      color: Colors.black54,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              // FIX: was showing default "Just now" always because the
              // caller (admin_user_posts.dart) wasn't passing `timed:`.
              // Now that the caller passes a real formatted date, this
              // renders correctly.
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
                // FIX: wrapped in GestureDetector as a safety net so the
                // "View all comments" tap fires reliably even if
                // TexxtButton's internal tap handling is the broken part.
                // Whichever one actually receives the touch, viewCommentonTap
                // will now be called.
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: viewCommentonTap,
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
              ),
            ],
          ),
          const SizedBox(height: 20),
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
