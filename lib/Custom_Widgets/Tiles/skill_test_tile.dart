import 'package:flutter/material.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';

class SkillTestTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onTap;
  final String? imagePath;
  final IconData? icon;
  final Gradient? gradient; // ✅ Optional gradient parameter

  const SkillTestTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonText = "START",
    this.onTap,
    this.imagePath,
    this.icon,
    this.gradient, // ✅
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        gradient:
            gradient ??
            ElevateGradientColors.grayToBlack, // ✅ fallback to default
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: const BoxDecoration(
              color: Color.fromARGB(0, 255, 255, 255),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: imagePath != null
                  ? ClipOval(
                      child: Image.asset(
                        imagePath!,
                        height: 60,
                        width: 60,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Icon(icon ?? Icons.code, color: Colors.orange, size: 28),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
