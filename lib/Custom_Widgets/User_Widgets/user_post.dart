import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
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
  final int date;
  final String month;
  final int year;
  final int commentCount;
  final Color borderolor;
  final int borderSize;

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
    this.date = 12,
    this.commentCount = 0,
    this.month = "Dec",
    this.year = 2025,
    this.borderolor = ElevateColor.gray,
    this.borderSize = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Container(
          width: 350,
          decoration: BoxDecoration(
            color: ElevateColor.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: borderSize.toDouble(), color: borderolor),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: SingleChildScrollView(
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
                        text: "$date-$month-$year",
                        fontSize: 10,
                        color: ElevateColor.gray,
                        fontWeight: FontWeight.w500,
                        lineHeight: lineHeight,
                        textAlign: textAlign,
                        maxLines: maxLines,
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  CustomText(
                    text: postTitle,
                    fontSize: 13,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    lineHeight: lineHeight,
                    textAlign: textAlign,
                    maxLines: maxLines,
                  ),
                  SizedBox(height: 15),
                  CustomText(
                    text: postText,
                    fontSize: textSize,
                    color: textColor,
                    fontWeight: textWeight,
                    lineHeight: lineHeight,
                    textAlign: textAlign,
                    maxLines: maxLines,
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: IconText(
                          text: commentCount.toString(),
                          textWeight: FontWeight.bold,
                          iconData: Icons.chat_bubble_outline,
                        ),
                      ),
        
                      TexxtButton(text: "View all comments"
                      , textSize: 12,textWeight: FontWeight.bold,
                      textColor: ElevateColor.whitegray,
                      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
                      width: 230,
                      height: 40,
                      borderRadius: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
