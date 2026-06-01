import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class CommunityPostCard extends StatelessWidget {
  final String initials;
  final String name;
  final String role;
  final String dateLabel;
  final String title;
  final String body;
  final int commentCount;

  const CommunityPostCard({
    super.key,
    required this.initials,
    required this.name,
    required this.role,
    required this.dateLabel,
    required this.title,
    required this.body,
    this.commentCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: ElevateColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ElevateColor.gray.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: avatar + name/role + date
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    gradient: ElevateGradientColors.grayToBlack,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Center(
                    child: CustomText(
                      text: initials,
                      fontSize: 14,
                      color: ElevateColor.white,
                      fontWeight: FontWeight.w600,
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
                        fontSize: 13,
                        color: ElevateColor.gray,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 2),
                      CustomText(
                        text: role.toUpperCase(),
                        fontSize: 10,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                CustomText(
                  text: dateLabel,
                  fontSize: 10,
                  color: ElevateColor.whitegray,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Title
            CustomText(
              text: title,
              fontSize: 13,
              color: ElevateColor.gray,
              fontWeight: FontWeight.w600,
            ),

            const SizedBox(height: 10),

            // Body text
            CustomText(
              text: body,
              fontSize: 12,
              color: ElevateColor.gray,
              fontWeight: FontWeight.w400,
              lineHeight: 1.5,
            ),

            const SizedBox(height: 18),

            // Footer row: comments count + "View all comments" pill
            Row(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      size: 18,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 6),
                    CustomText(
                      text: commentCount.toString(),
                      fontSize: 12,
                      color: ElevateColor.gray,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  child: CustomText(
                    text: "View all comments",
                    fontSize: 11,
                    color: ElevateColor.whitegray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

