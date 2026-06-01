import 'package:flutter/material.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';

class UserSkill extends StatelessWidget {
  final String title;
  final String? subtitle;

  final double titleSize;
  final Color titleColor;
  final FontWeight titleWeight;
  final double titleLineHeight;
  final int? titleMaxLines;

  final double subtitleSize;
  final Color subtitleColor;
  final FontWeight subtitleWeight;
  final double subtitleLineHeight;
  final int? subtitleMaxLines;

  // Image 
  final String imagePath;
  final double imageSize;
  final int imageTextSpace;

  // Year
  final String year;
  final Color yearTextColor;
  final double yearTextSize;

  // Card
  final EdgeInsets padding;
  final double borderRadius;
  final Color borderColor;
    final int borderHeight;
  final int borderWidth;

  const UserSkill({
    super.key,
    required this.title,
    this.subtitle,
    required this.imagePath,
    required this.year,

    this.titleSize = 14,
    this.titleColor = ElevateColor.lightgray,
    this.titleWeight = FontWeight.w700,
    this.titleLineHeight = 1.2,
    this.titleMaxLines,

    this.subtitleSize = 12,
    this.subtitleColor = ElevateColor.gray,
    this.subtitleWeight = FontWeight.normal,
    this.subtitleLineHeight = 1.2,
    this.subtitleMaxLines,

    this.imageSize = 42,
    this.imageTextSpace = 12,

    this.yearTextColor = ElevateColor.black,
    this.yearTextSize = 12,

    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    this.borderRadius = 12,
    this.borderColor = ElevateColor.gray,
        this.borderHeight = 25,
    this.borderWidth = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image from assets
          Image.asset(
            imagePath,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.contain,
          ),

          SizedBox(width: imageTextSpace.toDouble()),

          // Title & subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontSize: titleSize,
                  color: titleColor,
                  fontWeight: titleWeight,
                  lineHeight: titleLineHeight,
                  maxLines: titleMaxLines,
                  overflow: titleMaxLines != null
                      ? TextOverflow.ellipsis
                      : TextOverflow.visible,
                ),
                if (subtitle != null)
                  CustomText(
                    text: subtitle!,
                    fontSize: subtitleSize,
                    color: subtitleColor,
                    fontWeight: subtitleWeight,
                    lineHeight: subtitleLineHeight,
                    maxLines: subtitleMaxLines,
                    overflow: subtitleMaxLines != null
                        ? TextOverflow.ellipsis
                        : TextOverflow.visible,
                  ),
              ],
            ),
          ),

          // Year
         Container(
            width: borderWidth.toDouble(),
            height: borderHeight.toDouble(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: borderColor),
            ),
            child: Center(
              child: CustomText(
                text: year,
                fontSize: yearTextSize,
                color: yearTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}