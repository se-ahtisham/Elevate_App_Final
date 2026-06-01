import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final double lineHeight; 
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow; 

  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.lineHeight = 1.5,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.visible,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        height: lineHeight,
      ),
    );
  }
}
