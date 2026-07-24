import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

  └── CustomText (subTitle)
 */
class ElevateHeader extends StatelessWidget {
  final String title;
  final double titleSize;
  final double subtitleSize;
  final String subTitle;
  final double titleLineHeight;
  final double subtitleLineHeight;
  final bool showBackButton;
  final VoidCallback? onBackTap;

  const ElevateHeader({
    super.key,
    this.title = "",
    this.subTitle = "",
    this.titleSize = 27,
    this.subtitleSize = 14,
    this.titleLineHeight = 1.6,
    this.subtitleLineHeight = 1.0,
    this.showBackButton = false,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            gradient: ElevateGradientColors.grayToBlack,
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 20, top: 60),
          child: Image.asset(
            'lib/Resources/Images/Elevate_Large_Logo.png',
            width: 410,
          ),
        ),

        if (showBackButton)
          Positioned(
            top: 60,
            right: 20,
            child: TexxtButton(
              text: "Back",
              width: 100,
              height: 40,
              textSize: 12,
              textWeight: FontWeight.w500,
              textColor: const Color.fromARGB(255, 255, 255, 255),
              backgroundColor: const Color.fromARGB(224, 114, 114, 114),
              borderColor: const Color(0xFF8B8B8B),
              borderRadius: 80,
              borderWidth: 1,
              onTap: onBackTap ?? () => Navigator.pop(context),
            ),
          ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 75, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('lib/Resources/Images/Elevate_Logo.png', width: 100),
              const SizedBox(height: 50),
              CustomText(
                text: title,
                fontSize: titleSize,
                color: ElevateColor.white,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.left,
                lineHeight: titleLineHeight,
              ),
              CustomText(
                text: subTitle,
                fontSize: subtitleSize,
                color: ElevateColor.white,
                fontWeight: FontWeight.w300,
                textAlign: TextAlign.left,
                lineHeight: subtitleLineHeight,
              ),
            ],
          ),
        ),
      ],
    );
  }
}