import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:flutter/material.dart';


class CustomGradientTextBox extends StatelessWidget {

  final String text;
  final double textSize;
  final Color textColor;
  final FontWeight textWeight;
  final AlignmentGeometry textAlignment;
  final double lineHeight;
  final TextAlign textAlign;
  final int? maxLines;

  final Color startColor;
  final Color endColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double? width;
  final double? height;

  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;

  final double marginLeft;
  final double marginRight;
  final double marginTop;
  final double marginBottom;


  const CustomGradientTextBox({ super.key,
    required this.text,
    this.textSize = 14,
    this.textColor = Colors.white,
    this.textWeight = FontWeight.normal,
    this.textAlignment = Alignment.centerLeft,
    this.lineHeight = 1.5,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.startColor = Colors.blue,
    this.endColor = Colors.purple,
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
        //You cannot directly put your CustomGradient inside BoxDecoration, because it is a widget, not a gradient object.
        gradient: LinearGradient(
          colors: [startColor, endColor],
        ),
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: CustomText(
        text: text,
        fontSize: textSize,
        color: textColor,
        fontWeight: textWeight,
        lineHeight: lineHeight,
        textAlign: textAlign,
        maxLines: maxLines,
      ),
    );
  }
}



