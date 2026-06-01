import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class AdminBadgeCreateCard extends StatelessWidget {
  final String code;
  final VoidCallback? onCreate;
  const AdminBadgeCreateCard({
    super.key,
    required this.code,
    this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 154,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: ElevateColor.gray,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, size: 22, color: ElevateColor.gray),
          ),
          const SizedBox(height: 10),
          CustomText(
            text: code,
            fontSize: 17,
            color: ElevateColor.white,
            fontWeight: FontWeight.w700,
            lineHeight: 1.0,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onCreate,
            child: Container(
              height: 32,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              alignment: Alignment.center,
              child: CustomText(
                text: "CREATE NOW",
                fontSize: 10.5,
                color: ElevateColor.gray,
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

