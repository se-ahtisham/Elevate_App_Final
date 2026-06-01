import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class AdminBottomNav extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int>? onTap;

  const AdminBottomNav({super.key, this.activeIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFB155FF);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    Widget navItem({
      required int index,
      required IconData icon,
      required String label,
      required bool showLabel,
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
                  size: 20,
                  color: isActive ? accent : ElevateColor.gray,
                ),
                const SizedBox(height: 4),
                if (showLabel)
                  CustomText(
                    text: label,
                    fontSize: 10,
                    color: isActive ? accent : Colors.transparent,
                    fontWeight: FontWeight.w700,
                    lineHeight: 1.0,
                  )
                else
                  const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      height: 74 + bottomInset,
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Color(0xFFF4F4F4),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Row(
        children: [
          navItem(
            index: 0,
            icon: Icons.grid_view_rounded,
            label: "Dashboard",
            showLabel: true,
          ),
          navItem(
            index: 1,
            icon: Icons.work_outline_rounded,
            label: "",
            showLabel: false,
          ),
          navItem(
            index: 2,
            icon: Icons.person_outline_rounded,
            label: "",
            showLabel: false,
          ),
        ],
      ),
    );
  }
}

