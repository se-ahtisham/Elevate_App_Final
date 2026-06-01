import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class ElevateBottomNav extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int>? onTap;

  const ElevateBottomNav({
    super.key,
    required this.activeIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFB155FF);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    Widget item({
      required int index,
      required IconData icon,
      required String label,
    }) {
      final isActive = index == activeIndex;

      return Expanded(
        child: InkWell(
          onTap: onTap == null ? null : () => onTap!(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isActive ? accent : ElevateColor.gray,
                ),
                const SizedBox(height: 6),
                CustomText(
                  text: label,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isActive ? accent : Colors.transparent,
                  lineHeight: 1.0,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      height: 84 + bottomInset,
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: ElevateColor.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, -8),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: Row(
        children: [
          item(index: 0, icon: Icons.work_outline_rounded, label: " "),
          item(index: 1, icon: Icons.show_chart_rounded, label: " "),
          item(index: 2, icon: Icons.search_rounded, label: " "),
          item(index: 3, icon: Icons.apartment_rounded, label: " "),
          item(index: 4, icon: Icons.person_outline_rounded, label: "Profile"),
        ],
      ),
    );
  }
}

