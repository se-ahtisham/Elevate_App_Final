
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:flutter/material.dart';

/* Button with inside Icon and text with gradient color */ 

class IconTextButtonGradient extends StatelessWidget {
  final String text;
  final double textSize;
  final Color textColor;
  final FontWeight textWeight;
  final double lineHeight;
  final TextAlign textAlign;
  final int? maxLines;

  final Color startColor; 
  final Color endColor;   
  final AlignmentGeometry start; 
  final AlignmentGeometry end;   
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;

  final double marginLeft;
  final double marginRight;
  final double marginTop;
  final double marginBottom;

  final Color rippleColor;

  final IconData iconData; 
  final double iconSize;
  final Color iconColor; 
  final double iconTextSpacing;

  const IconTextButtonGradient({
    super.key,
    required this.text,
    required this.iconData,
    this.iconSize = 20,
    this.iconColor = Colors.white,
    this.iconTextSpacing = 4.0,
    this.textSize = 14,
    this.textColor = Colors.white,
    this.textWeight = FontWeight.normal,
    this.lineHeight = 1.5,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.startColor = Colors.blue,
    this.endColor = Colors.blueAccent,
    this.start = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.borderColor = Colors.transparent,
    this.borderWidth = 1,
    this.borderRadius = 8,
    this.width,
    this.height,
    this.onTap,
    this.paddingLeft = 8,
    this.paddingRight = 8,
    this.paddingTop = 4,
    this.paddingBottom = 4,
    this.marginLeft = 0,
    this.marginRight = 0,
    this.marginTop = 0,
    this.marginBottom = 0,
    this.rippleColor = Colors.white54,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(marginLeft, marginTop, marginRight, marginBottom),
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: start,
          end: end,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: rippleColor,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(paddingLeft, paddingTop, paddingRight, paddingBottom),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, size: iconSize, color: iconColor),
              SizedBox(width: iconTextSpacing),
              CustomText(
                text: text,
                fontSize: textSize,
                color: textColor,
                fontWeight: textWeight,
                lineHeight: lineHeight,
                textAlign: textAlign,
                maxLines: maxLines,
              ),
            ],
          ),
        ),
      ),
    );
  }
}