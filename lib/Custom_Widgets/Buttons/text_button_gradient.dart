import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:flutter/material.dart';


/* Button with inside Text with Gradient color */ 

class TextButtonGradient extends StatelessWidget {
  final String text;
  final double textSize;
  final Color textColor;
  final FontWeight textWeight;
  final AlignmentGeometry textAlignment;
  final double lineHeight;
  final TextAlign textAlign;
  final int? maxLines;

  final Gradient buttonBackgroundColor;
  final AlignmentGeometry gradientBegin; 
  final AlignmentGeometry gradientEnd; 
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

  const TextButtonGradient({
    super.key,
    required this.text,
    this.textSize = 14,
    this.textColor = Colors.white,
    this.textWeight = FontWeight.normal,
    this.textAlignment = Alignment.center,
    this.lineHeight = 1.5,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.buttonBackgroundColor = ElevateGradientColors.grayToBlack,
    this.gradientBegin = Alignment.topLeft,
    this.gradientEnd = Alignment.bottomRight,
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
        gradient: buttonBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: rippleColor,
          onTap: onTap,
          child: Container(
            alignment: textAlignment,
            padding: EdgeInsets.fromLTRB(paddingLeft, paddingTop, paddingRight, paddingBottom),
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
        ),
      ),
    );
  }
}