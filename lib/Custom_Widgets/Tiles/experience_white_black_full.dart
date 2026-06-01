import 'package:elevate_app/Custom_Widgets/Buttons/circle_icon_button.dart';
import 'package:elevate_app/Custom_Widgets/Text_background_box/custom_text_box.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description_short.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class ExperienceWhiteBlackFull extends StatelessWidget {
  final double tileHeight;
  final double firstContainerWidth;
  final double secondContainerWidth;
  final double experienceBoxWidth;
  final Color? backgroundColor;
  final double borderRadius;
  final VoidCallback? onTap;

  final String imageURL;
  final String name;
  final String shortDescription;
  final String experience;
  final double iconSize;
  final Color iconColor;
  final double circleSize;
  final Color circleColor;

  const ExperienceWhiteBlackFull({
    super.key,

    this.tileHeight = 120,
    this.firstContainerWidth = 280,
    this.secondContainerWidth = 80,
    this.experienceBoxWidth = 250,
    this.backgroundColor,
    this.borderRadius = 12,
    this.onTap,
    required this.imageURL,
    required this.name,
    required this.shortDescription,
    this.experience = "No Experience",

    this.iconSize = 24,
    this.iconColor = Colors.black,
    this.circleSize = 40,
    this.circleColor = Colors.white,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserDescriptionShort(
                  imageURL: imageURL,
                  name: name,
                  shortDescription: shortDescription,
                ),
                SizedBox(height: 10),
                CustomTextBox(
                        text: experience,
                        backgroundColor: const Color.fromARGB(92, 196, 196, 196),
                        borderRadius: 50,
                        textColor: const Color.fromARGB(255, 61, 61, 61),
                        borderWidth: 0.8,
                        borderColor: const Color.fromARGB(255, 190, 190, 190),
                       width: experienceBoxWidth,
                        textSize: 10,
                        height: 30,
                      ),
              ],
            ),
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
