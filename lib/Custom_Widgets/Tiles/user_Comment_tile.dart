import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description_short.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class UserCommentTile extends StatelessWidget {
  final String title;
  final String text;

  final String imageURL;
  final String name;
  final String shortDescription;

  final VoidCallback? onTap;
  final VoidCallback? onDeleteTap;

  const UserCommentTile({
    super.key,
    required this.title,
    required this.text,
    required this.imageURL,
    required this.name,
    required this.shortDescription,
    this.onTap,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ElevateColor.gray),
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
              if (onDeleteTap != null)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 25,
                    color: Color.fromARGB(255, 22, 22, 22),
                  ),
                  onPressed: onDeleteTap,
                ),
            ],
          ),
          if (title.isNotEmpty) ...[
            const SizedBox(height: 12),
            CustomText(text: title, fontSize: 14, fontWeight: FontWeight.bold),
          ],
          const SizedBox(height: 8),
          CustomText(
            text: text,
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}
