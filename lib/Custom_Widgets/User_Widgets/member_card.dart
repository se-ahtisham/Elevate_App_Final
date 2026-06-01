import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class MemberCard extends StatelessWidget {
  final String initials;
  final String name;
  final String role;
  final VoidCallback? onTap;

  const MemberCard({
    super.key,
    required this.initials,
    required this.name,
    required this.role,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        // Light gray background like other cards in the app
        color: ElevateColor.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: ElevateColor.gray.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Row(
          children: [
            // Left side: avatar + name & role
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        gradient: ElevateGradientColors.grayToBlack,
                        borderRadius: BorderRadius.circular(23),
                      ),
                      child: Center(
                        child: CustomText(
                          text: initials,
                          fontSize: 18,
                          color: ElevateColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: name,
                            fontSize: 13,
                            color: ElevateColor.black,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 3),
                          CustomText(
                            text: role,
                            fontSize: 11,
                            color: ElevateColor.whitegray,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Right side: dark strip with arrow icon using theme blacks
            InkWell(
              onTap: onTap,
              child: Container(
                width: 56,
                height: 76,
                decoration: const BoxDecoration(
                  gradient: ElevateGradientColors.grayToBlack,
                ),
                child: const Icon(
                  Icons.arrow_outward_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

