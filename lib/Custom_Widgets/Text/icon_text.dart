import 'package:flutter/material.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';



/*StatelessWidget: IconText
└── Row
    ├── Icon (iconData)
    ├── SizedBox (width: iconTextSpacing)
    └── Flexible
        └── CustomText (text)
        */ 


class IconText extends StatelessWidget {
  final String text;
  final double textSize;
  final Color textColor;
  final FontWeight textWeight;
  final double lineHeight;
  final TextAlign textAlign;
  final int? maxLines;

  final IconData iconData;
  final double iconSize;
  final Color iconColor;
  final double iconTextSpacing;

  const IconText({
    super.key,
    required this.text,
    this.textSize = 14,
    this.textColor = Colors.black,
    this.textWeight = FontWeight.normal,
    this.lineHeight = 1.2,
    this.textAlign = TextAlign.left,
    this.maxLines,
    required this.iconData,
    this.iconSize = 20,
    this.iconColor = Colors.black,
    this.iconTextSpacing = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
     
      children: [
        Icon(
          iconData,
          size: iconSize,
          color: iconColor,
        ),
        SizedBox(width: iconTextSpacing),
        Flexible(  // Ensure does not overflow
          child: CustomText(
            text: text,
            textAlign: textAlign,
            fontSize: textSize,
            color: textColor,
            fontWeight: textWeight,
            lineHeight: lineHeight,
            maxLines: maxLines,
            overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}