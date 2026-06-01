import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class UserWork extends StatelessWidget {
  final String title;
  final String subtitle;

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

  // Icon
  final IconData iconData;
  final double iconSize;
  final Color iconColor;
  final int iconTextSpace;

  // Status
 final String startDate;
final String? endDate;
  final Color statusTextColor;
  final double statusTextSize;

  // Card
  final EdgeInsets padding;
  final double borderRadius;
  final Color borderColor;
  final int borderHeight;
  final int borderWidth;

  const UserWork({
    super.key,
    required this.title,
    this.subtitle = "",
    required this.iconData,

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

    this.iconSize = 22,
    this.iconColor = ElevateColor.lightgray,
    this.iconTextSpace = 12,

    this.statusTextColor = ElevateColor.black,
    this.statusTextSize = 11,
    this.startDate = "",
    this.endDate = "",

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
          // Icon
          Icon(iconData, size: iconSize, color: iconColor),
          SizedBox(width: iconTextSpace.toDouble()),
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
                CustomText(
                  text: subtitle,
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
          SizedBox(width: 5),
          // Status text
          Container(
            width: borderWidth.toDouble(),
            height: borderHeight.toDouble(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: borderColor),
            ),
            child: Center(
              child: CustomText(
                text: endDate == null ? "Current Job" : "$startDate - $endDate",
                fontSize: statusTextSize,
                color: statusTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
