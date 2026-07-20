import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:flutter/material.dart';

class JobSkillFilterChip extends StatelessWidget {
  final String skillName;
  final String tier;
  final bool isActive;
  final VoidCallback onTap;

  const JobSkillFilterChip({
    super.key,
    required this.skillName,
    required this.tier,
    required this.isActive,
    required this.onTap,
  });

  Color getTierColor() {
    if (tier == 'Gold') return const Color(0xFFD4A017);
    if (tier == 'Silver') return const Color(0xFF9CA3AF);
    return const Color(0xFFB45309);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive ? Colors.black : const Color(0xFFE0DED8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: getTierColor(),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            CustomText(
              text: skillName,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
