import 'package:elevate_app/Custom_Widgets/Buttons/circle_icon_button.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class ManageWhiteBlackFull extends StatelessWidget {
  final String titleText;
  final String subtitleText;

  final double titleFontSize;
  final Color? titleColor;
  final FontWeight titleFontWeight;

  final double subtitleFontSize;
  final Color? subtitleColor;
  final FontWeight subtitleFontWeight;

  final double lineHeight;
  final double sizedBetween;

  final double tileHeight;
  final double firstContainerWidth;
  final double secondContainerWidth;

  final double iconSize;
  final Color iconColor;
  final double circleSize;
  final Color circleColor;
  final Color firstContainerColor;
  final double borderWidth;
  final Color borderColor;
  final VoidCallback? onTap;

  const ManageWhiteBlackFull({
    super.key,
    required this.titleText,
    required this.subtitleText,

    this.titleFontSize = 16,
    this.titleColor,
    this.titleFontWeight = FontWeight.normal,

    this.subtitleFontSize = 20,
    this.subtitleColor,
    this.subtitleFontWeight = FontWeight.bold,

    this.lineHeight = 1.2,
    this.sizedBetween = 4,

    this.tileHeight = 90,
    this.firstContainerWidth = 180,
    this.secondContainerWidth = 90,
    this.firstContainerColor = ElevateColor.white,

    this.iconSize = 18,
    this.iconColor = Colors.white,
    this.circleSize = 36,
    this.circleColor = Colors.transparent,
    this.borderWidth = 2,
    this.borderColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // First Section
        Container(
          height: tileHeight,
          width: firstContainerWidth,
          padding:   EdgeInsets.only(left: 16),
          decoration:   BoxDecoration(
            color: firstContainerColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              bottomLeft: Radius.circular(18),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CustomText(
                text: titleText,
                fontSize: titleFontSize,
                color: titleColor,
                fontWeight: titleFontWeight,
                lineHeight: lineHeight,
                textAlign: TextAlign.left,
              ),

              SizedBox(height: sizedBetween),

              CustomText(
                text: subtitleText,
                fontSize: subtitleFontSize,
                color: subtitleColor,
                fontWeight: subtitleFontWeight,
                lineHeight: lineHeight,
                textAlign: TextAlign.left,
              ),

            ],
          ),
        ),

        // Second Section
        Container(
          width: secondContainerWidth,
          height: tileHeight,
          decoration:  BoxDecoration(
            gradient: ElevateGradientColors.grayToBlack,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
          child: Center(
            child: CircleIconButton(
              iconData: Icons.arrow_outward,
              iconSize: iconSize,
              iconColor: iconColor,
              circleSize: circleSize,
              circleColor: circleColor,
              borderWidth: borderWidth,
              borderColor: borderColor,
              onTap: onTap,
            ),
          ),
        ),

      ],
    );
  }
}