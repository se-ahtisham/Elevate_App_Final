import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final double lineHeight;

  final Color hintColor;
  final FontWeight hintWeight;

  final Color cursorColor;
  final Color underlineColor;

  final EdgeInsets contentPadding;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.cursorColor,
    required this.underlineColor,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.textColor = Colors.black,
    this.lineHeight = 1,
     this. obscureText = false,

    this.hintColor = const Color(0xFFC5C5C5),
    this.hintWeight = FontWeight.w400,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,                   
      cursorColor: cursorColor,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: textColor,
        height: lineHeight,
        decoration: TextDecoration.none,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: hintWeight,
          color: hintColor,
          height: lineHeight,
          decoration: TextDecoration.none,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: underlineColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: underlineColor),
        ),
        isDense: true,
        contentPadding: contentPadding,
      ),
    );
  }
}