import 'package:elevate_app/Custom_Widgets/Buttons/circle_icon_button.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description_short.dart';
import 'package:flutter/material.dart';

class ShortDescriptionRoundCircleIconTile extends StatelessWidget {
  final double height;
  final double width;
  final Color? backgroundColor;
  final double borderRadius;
  final VoidCallback? onTap;

  final String imageURL;
  final String name;
  final String shortDescription;

  final IconData iconData;
  final double iconSize;
  final Color iconColor;
  final double circleSize;
  final Color circleColor;
  final double borderWidth;
  final Color borderColor;

  const ShortDescriptionRoundCircleIconTile({
    super.key,
    required this.height,
    required this.width,
    this.backgroundColor,
    this.borderRadius = 12,
    this.onTap,
    required this.imageURL,
    required this.name,
    required this.shortDescription,
    required this.iconData,
    required this.iconSize,
    required this.iconColor,
    required this.circleSize,
    required this.circleColor,
    required this.borderWidth,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: UserDescriptionShort(
                imageURL: imageURL,
                name: name,
                shortDescription: shortDescription,
              ),
            ),
            CircleIconButton(
              iconData: iconData,
              iconSize: iconSize,
              iconColor: iconColor,
              circleSize: circleSize,
              circleColor: circleColor,
              borderWidth: borderWidth,
              borderColor: borderColor,
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}