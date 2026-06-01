import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:flutter/material.dart';


class CustomTextBox extends StatelessWidget {

 // Text Properties
  final String text;
  final double textSize;
  final Color textColor;
  final FontWeight textWeight;
  final AlignmentGeometry textAlignment;
  final double lineHeight;
  final TextAlign textAlign;
  final int? maxLines;

  // Box Properties
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double? width;
  final double? height;

  // Padding
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;

  // Margin
  final double marginLeft;
  final double marginRight;
  final double marginTop;
  final double marginBottom;

  const CustomTextBox({super.key,
    required this.text,
    this.textSize = 14,
    this.textColor = Colors.black,
    this.textWeight = FontWeight.normal,
    this.textAlignment = Alignment.centerLeft,
    this.lineHeight = 1.5,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.borderWidth = 1,
    this.borderRadius = 8,
    this.width,
    this.height,
    this.paddingLeft = 8,
    this.paddingRight = 8,
    this.paddingTop = 4,
    this.paddingBottom = 4,
    this.marginLeft = 0,
    this.marginRight = 0,
    this.marginTop = 0,
    this.marginBottom = 0,});

@override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        marginLeft,
        marginTop,
        marginRight,
        marginBottom,
      ),
      width: width,
      height: height,
      alignment: textAlignment,
      padding: EdgeInsets.fromLTRB(
        paddingLeft,
        paddingTop,
        paddingRight,
        paddingBottom,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: CustomText(
          text: text,
          fontSize: textSize,
          color: textColor,
          fontWeight: textWeight,
          lineHeight: lineHeight,
          textAlign: textAlign,
          maxLines: maxLines,
        ),
      ),
    );
  }
}