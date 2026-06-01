import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class AdminBadgeResultCard extends StatelessWidget {
  final String badgeImagePath;
  final String badgeCode;
  final VoidCallback? onManage;

  const AdminBadgeResultCard({
    super.key,
    required this.badgeImagePath,
    required this.badgeCode,
    this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(16),
        // Outer outline like the reference screen
        border: Border.all(color: const Color(0xFF8F8F8F), width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 223, 255, 226),
                    ),
                    child: Image.asset(
                      badgeImagePath,
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomText(
                      text: badgeCode,
                      fontSize: 14,
                      color: ElevateColor.gray,
                      fontWeight: FontWeight.w700,
                      lineHeight: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: onManage,
            child: Container(
              width: 84,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: ElevateGradientColors.grayToBlack,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: Colors.white,
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

