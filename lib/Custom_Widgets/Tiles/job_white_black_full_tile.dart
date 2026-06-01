import 'package:elevate_app/Custom_Widgets/Buttons/circle_icon_button.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Text_background_box/custom_text_box.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';


/*jobWhiteBlackFullTile
└── Row
    ├── Container (Job Info Section)
    │   └── Column
    │       ├── CustomText (titleText)
    │       ├── SizedBox
    │       ├── CustomText (subtitleText)
    │       ├── SizedBox
    │       └── Row
    │           ├── CustomTextBox (jobModeText)
    │           ├── CustomTextBox (jobTypeText)
    │           └── CustomTextBox (salaryText)
    │
    └── Container (Action Section)
        └── Center
            └── CircleIconButton */




class JobWhiteBlackFullTile extends StatelessWidget {
  final String titleText;
  final double titleFontSize;
  final FontWeight titleFontWeight;

  final double spaceBetweenTitleSubtitle;

  final String subtitleText;
  final double subtitleFontSize;
  final FontWeight subtitleFontWeight;

  final double spaceBetweenSubtitleBlocks;

  final String jobTypeText;
  final String jobModeText;
  final String salaryText;

  final double blockFontSize;
  final FontWeight blockFontWeight;
  final double sizedBetween;

  final double smallBoxWdith;

  final double tileHeight;
  final double firstContainerWidth;
  final double secondContainerWidth;

  final double iconSize;
  final Color iconColor;
  final double circleSize;
  final Color circleColor;
  final VoidCallback? onTap;

  const JobWhiteBlackFullTile({
    super.key,
    this.titleText = "",
    this.titleFontSize = 16,
    this.titleFontWeight = FontWeight.bold,
    this.spaceBetweenTitleSubtitle = 6,
    this.subtitleText = "",
    this.subtitleFontSize = 14,
    this.subtitleFontWeight = FontWeight.normal,
    this.spaceBetweenSubtitleBlocks = 8,
    this.jobTypeText = "",
    this.jobModeText = "",
    this.salaryText = "",
    this.blockFontSize = 12,
    this.blockFontWeight = FontWeight.normal,
    this.sizedBetween = 5,
    this.smallBoxWdith = 80,
    this.tileHeight = 120,
    this.firstContainerWidth = 220,
    this.secondContainerWidth = 80,
    this.iconSize = 24,
    this.iconColor = Colors.black,
    this.circleSize = 40,
    this.circleColor = Colors.white,
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
          padding: EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: ElevateColor.white,
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
                color: ElevateColor.gray,
                fontWeight: titleFontWeight,
                lineHeight: 0.8,
                textAlign: TextAlign.left,
              ),
              SizedBox(height: spaceBetweenTitleSubtitle),
              CustomText(
                text: subtitleText,
                fontSize: subtitleFontSize,
                color: ElevateColor.gray,
                fontWeight: subtitleFontWeight,
                lineHeight: 0.8,
                textAlign: TextAlign.left,
              ),
              SizedBox(height: spaceBetweenSubtitleBlocks),
              Row(
                children: [
                  CustomTextBox(
                    text: jobModeText,
                    backgroundColor: const Color.fromARGB(255, 231, 231, 231),
                    borderRadius: 50,
                    textSize: blockFontSize,
                    width: smallBoxWdith,
                  ),
                  SizedBox(width: sizedBetween),
                  CustomTextBox(
                    text: jobTypeText,
                   backgroundColor: const Color.fromARGB(255, 231, 231, 231),
                    borderRadius: 50,
                    textSize: blockFontSize,
                    width: smallBoxWdith,
                  ),
                  SizedBox(width: sizedBetween),
                  CustomTextBox(
                    text: salaryText,
                    backgroundColor: const Color.fromARGB(255, 231, 231, 231),
                    borderRadius: 50,
                    textSize: blockFontSize,
                    width: smallBoxWdith,
                  ),
                  SizedBox(width: sizedBetween),
                ],
              ),
            ],
          ),
        ),

        // Second Section
        Container(
          width: secondContainerWidth,
          height: tileHeight,
          decoration: BoxDecoration(
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
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}
