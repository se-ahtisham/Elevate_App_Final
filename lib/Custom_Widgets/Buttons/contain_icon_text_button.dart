import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:flutter/material.dart';

class ContainIconTextButton extends StatelessWidget {
  final VoidCallback? onTap;

  final String text;
  final double height;
  final double width;

  final Color backgroundColor;
  final Color textColor;

  final double borderRadius;

  final double iconSize;
  final Color iconColor;
  final Color iconBorderColor;
  final double iconContainerSize;

  final double textSize;
  final FontWeight fontWeight;

  const ContainIconTextButton({
    super.key,
    this.onTap,
    this.text = "Add More Work",
    this.height = 60,
    this.width = double.infinity,
    this.backgroundColor = const Color(0xFFE5E7EB),
    this.textColor = Colors.grey,
    this.borderRadius = 30,
    this.iconSize = 20,
    this.iconColor = Colors.grey,
    this.iconBorderColor = Colors.grey,
    this.iconContainerSize = 36,
    this.textSize = 16,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 26),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          children: [
            Container(
              height: iconContainerSize,
              width: iconContainerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: iconBorderColor),
              ),
              child: Icon(Icons.add, size: iconSize, color: iconColor),
            ),

            const SizedBox(width: 12),
            CustomText(
              text: text,
              fontSize: textSize,
              color: textColor,
              fontWeight: fontWeight,
            ),
          ],
        ),
      ),
    );
  }
}
