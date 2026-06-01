import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomGradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final double lineHeight;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;

  final List<Color> gradientColors;
  final Alignment begin;
  final Alignment end;

  const CustomGradientText({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.lineHeight = 1.5,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.visible,
    this.gradientColors = const [Colors.blue, Colors.purple],
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    // Flutter’s TextStyle does NOT natively support a gradient property.
    //So in short:
    //Solid color → just TextStyle(color: ...) ✅
    //Gradient color → must use foreground Paint or ShaderMask ❌

    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: gradientColors,
        begin: begin,
        end: end,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      blendMode: BlendMode.srcIn,
      child: Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: fontWeight,
          height: lineHeight,
          color: Colors.white, // color will be replaced by gradient
        ),
      ),
    );
  }
}
