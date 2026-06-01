import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class AdminPortfolioTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const AdminPortfolioTile({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: ElevateColor.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF8D8D8D), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CustomText(
                text: title,
                fontSize: 15,
                color: ElevateColor.gray,
                fontWeight: FontWeight.w600,
                lineHeight: 1.1,
                maxLines: 2,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: ElevateGradientColors.grayToBlack,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(13),
                  bottomRight: Radius.circular(13),
                ),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ElevateColor.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: ElevateColor.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
