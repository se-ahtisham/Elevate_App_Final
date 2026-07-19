import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description_short.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class UserPostTile extends StatelessWidget {
  final String postID;
  final String timed;
  final String title;
  final String text;
  final int commentCount;
  final List<String> comments;

  final int likeCount;
  final bool isLiked;

  final String imageURL;
  final String name;
  final String shortDescription;

  final Color borderolor;
  final int borderSize;

  final VoidCallback? onDeleteTap;
  final VoidCallback? onCommentsTap;
  final VoidCallback? onLikeTap;

  const UserPostTile({
    super.key,
    required this.postID,
    this.timed = "Just now",
    required this.title,
    required this.text,
    required this.commentCount,
    required this.comments,
    this.likeCount = 0,
    this.isLiked = false,
    required this.imageURL,
    required this.name,
    required this.shortDescription,
    this.borderolor = ElevateColor.gray,
    this.borderSize = 1,
    this.onDeleteTap,
    this.onCommentsTap,
    this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Container(
          width: 350,
          decoration: BoxDecoration(
            color: ElevateColor.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: borderSize.toDouble(), color: borderolor),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
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
                    CustomText(
                      text: timed,
                      fontSize: 10,
                      color: ElevateColor.gray,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                CustomText(
                  text: title,
                  fontSize: 13,
                  color: ElevateColor.gray,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 15),
                CustomText(
                  text: text,
                  fontSize: 14,
                  color: ElevateColor.gray,
                  fontWeight: FontWeight.w400,
                  lineHeight: 1.5,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    GestureDetector(
                      onTap: onLikeTap,
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isLiked ? Colors.red : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          CustomText(
                            text: "$likeCount",
                            fontSize: 13,
                            color: ElevateColor.gray,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.chat_bubble_outline,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    CustomText(
                      text: "$commentCount",
                      fontSize: 13,
                      color: ElevateColor.gray,
                      fontWeight: FontWeight.w500,
                    ),
                    const Spacer(),
                    TexxtButton(
                      text: "View comments",
                      textSize: 12,
                      textWeight: FontWeight.bold,
                      textColor: ElevateColor.whitegray,
                      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                      width: 140,
                      height: 36,
                      borderRadius: 20,
                      onTap: onCommentsTap,
                    ),
                  ],
                ),

                if (onDeleteTap != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TexxtButton(
                      text: "Delete Post",
                      textSize: 12,
                      textWeight: FontWeight.bold,
                      textColor: const Color.fromARGB(255, 228, 228, 228),
                      backgroundColor: const Color.fromARGB(255, 54, 54, 54),

                      borderWidth: 1,
                      borderRadius: 20,
                      height: 36,
                      onTap: onDeleteTap,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
