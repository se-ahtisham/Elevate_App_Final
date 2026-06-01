import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class AdminTotalStatTile extends StatelessWidget {
  final String prefix;
  final String title;
  final int count;

  const AdminTotalStatTile({
    super.key,
    required this.prefix,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      decoration: BoxDecoration(
        color: ElevateColor.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: prefix,
                    fontSize: 26,
                    color: ElevateColor.lightgray,
                    fontWeight: FontWeight.w300,
                    lineHeight: 1.0,
                  ),
                  CustomText(
                    text: title,
                    fontSize: 25,
                    color: ElevateColor.black,
                    fontWeight: FontWeight.w700,
                    lineHeight: 1.0,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 72,
            decoration: BoxDecoration(
              gradient: ElevateGradientColors.grayToBlack,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Center(
              child: CustomText(
                text: "$count",
                fontSize: 28,
                color: ElevateColor.white,
                fontWeight: FontWeight.w700,
                lineHeight: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

