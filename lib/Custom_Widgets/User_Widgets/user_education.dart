import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';



/*StatelessWidget: IconDoubleText
└── Row (crossAxisAlignment: start)
    ├── Icon (iconData)
    ├── SizedBox (width: iconTextSpacing)
    └── Flexible
        └── Column (crossAxisAlignment: start)
            ├── CustomText (text)
            └── CustomText (subText) [if subText != null] */


class UserEducation extends StatelessWidget {
  final String text;
  final String? subText; 
  final double textSize;
  final Color textColor;
  final FontWeight textWeight;
  final double lineHeight;
  final TextAlign textAlign;
  final int? maxLines;

  final double subTextSize;
  final Color subTextColor;
  final FontWeight subTextWeight;
  final double subLineHeight;
  final TextAlign subTextAlign;
  final int? subMaxLines;

  final IconData iconData;
  final double iconSize;
  final Color iconColor;
  final double iconTextSpacing;

  const UserEducation({
    super.key,
    required this.text,
    this.subText,
    this.textSize = 13,
    this.textColor = ElevateColor.lightgray,
    this.textWeight = FontWeight.w700,
    this.lineHeight = 1.2,
    this.textAlign = TextAlign.left,
    this.maxLines,
    this.subTextSize = 11,
    this.subTextColor = ElevateColor.gray,
    this.subTextWeight = FontWeight.normal,
    this.subLineHeight = 1.2,
    this.subTextAlign = TextAlign.left,
    this.subMaxLines,
    required this.iconData,
    this.iconSize = 20,
    this.iconColor =ElevateColor.lightgray,
    this.iconTextSpacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          iconData,
          size: iconSize,
          color: iconColor,
        ),
        SizedBox(width: iconTextSpacing),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: text,
                fontSize: textSize,
                color: textColor,
                fontWeight: textWeight,
                lineHeight: lineHeight,
                textAlign: textAlign,
                maxLines: maxLines,
                overflow:
                    maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible,
              ),
              if (subText != null)
                CustomText(
                  text: subText!,
                  fontSize: subTextSize,
                  color: subTextColor,
                  fontWeight: subTextWeight,
                  lineHeight: subLineHeight,
                  textAlign: subTextAlign,
                  maxLines: subMaxLines,
                  overflow: subMaxLines != null
                      ? TextOverflow.ellipsis
                      : TextOverflow.visible,
                ),
            ],
          ),
        ),
      ],
    );
  }
}