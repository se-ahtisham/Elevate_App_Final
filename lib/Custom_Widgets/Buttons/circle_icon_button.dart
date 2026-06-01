import 'package:flutter/material.dart';

/* Circle Button with inside Icon with solid color */ 

class CircleIconButton extends StatelessWidget {
  final IconData iconData;
  final double iconSize;
  final Color iconColor;
  final double circleSize;
  final Color circleColor;
  final double borderWidth;
  final Color borderColor;

  final VoidCallback? onTap;
  final Color rippleColor;

  const CircleIconButton({
    super.key,
    required this.iconData,
    this.iconSize = 24,
    this.iconColor = Colors.white,
    this.circleSize = 50,
    this.circleColor = Colors.blue,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
    this.onTap,
    this.rippleColor = Colors.white54,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(circleSize / 2),
        splashColor: rippleColor,
        onTap: onTap,
        child: Container(
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
        ),
      ),
    );
  }
}