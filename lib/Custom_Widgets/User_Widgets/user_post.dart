import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description_short.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class UserPost extends StatelessWidget {
  final String userName;
  final String usershortDescription;
  final String image;
  final String postText;
  final String postTitle;

  final double textSize;
  final Color textColor;
  final FontWeight textWeight;
  final double lineHeight;
  final TextAlign textAlign;
  final int? maxLines;

  final DateTime? postDate;
  final int date;
  final String month;
  final int year;

  final int commentCount;
  final int likeCount;
  final bool isLiked;

  final Color borderolor;
  final int borderSize;

  final VoidCallback? onCommentsTap;
  final VoidCallback? onLikeTap;

  const UserPost({
    super.key,
    required this.userName,
    required this.postText,
    required this.postTitle,
    required this.image,
    required this.usershortDescription,
    this.textSize = 14,
    this.textColor = ElevateColor.gray,
    this.textWeight = FontWeight.w400,
    this.lineHeight = 1.5,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.postDate,
    this.date = 12,
    this.commentCount = 0,
    this.likeCount = 0,
    this.isLiked = false,
    this.month = "Dec",
    this.year = 2025,
    this.borderolor = ElevateColor.gray,
    this.borderSize = 1,
    this.onCommentsTap,
    this.onLikeTap,
  });

  String get dateLabel {
    if (postDate == null) return "$date-$month-$year";
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return "${postDate!.day}-${months[postDate!.month - 1]}-${postDate!.year}";
  }

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
                        imageURL: image,
                        name: userName,
                        shortDescription: usershortDescription,
                      ),
                    ),
                    CustomText(
                      text: dateLabel,
                      fontSize: 10,
                      color: ElevateColor.gray,
                      fontWeight: FontWeight.w500,
                      lineHeight: lineHeight,
                      textAlign: textAlign,
                      maxLines: maxLines,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                CustomText(
                  text: postTitle,
                  fontSize: 13,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  lineHeight: lineHeight,
                  textAlign: textAlign,
                  maxLines: maxLines,
                ),
                const SizedBox(height: 15),
                CustomText(
                  text: postText,
                  fontSize: textSize,
                  color: textColor,
                  fontWeight: textWeight,
                  lineHeight: lineHeight,
                  textAlign: textAlign,
                  maxLines: maxLines,
                ),
                const SizedBox(height: 20),

                // Like + comment row — now owned by the card, driven by
                // this post's own data only.
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                        size: 22,
                      ),
                      onPressed: onLikeTap,
                    ),
                    const SizedBox(width: 6),
                    CustomText(
                      text: "$likeCount likes",
                      fontSize: 13,
                      color: ElevateColor.gray,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(width: 16),
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
