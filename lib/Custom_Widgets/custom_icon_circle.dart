import 'package:flutter/material.dart';

class CustomIconCircle extends StatelessWidget {
  final IconData iconData;
  final double iconSize;
  final Color iconColor;
  final double circleSize;
  final Color circleColor;
  final double borderWidth;
  final Color borderColor;

  const CustomIconCircle({
    super.key,
    required this.iconData,
    this.iconSize = 24,
    this.iconColor = Colors.white,
    this.circleSize = 50,
    this.circleColor = Colors.blue,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        color: circleColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      alignment: Alignment.center,
      child: Icon(
        iconData,
        size: iconSize,
        color: iconColor,
      ),
    );
  }
}