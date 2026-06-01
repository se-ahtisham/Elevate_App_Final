import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class JobBottomNav extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int>? onItemTap;

  const JobBottomNav({super.key, this.activeIndex = 0, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: ElevateColor.white,
        border: Border(top: BorderSide(color: Color(0xFFEAEAEA))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(icon: Icons.work_outline_rounded, label: 'Jobs', index: 0),
          _item(icon: Icons.link_rounded, label: '', index: 1),
          _item(icon: Icons.send_outlined, label: '', index: 2),
          _item(icon: Icons.folder_open_outlined, label: '', index: 3),
          _item(icon: Icons.person_outline_rounded, label: '', index: 4),
        ],
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isActive = activeIndex == index;
    const activeColor = Color(0xFFE12EE5);
    const inactiveColor = Color(0xFF686868);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => onItemTap?.call(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: isActive ? activeColor : inactiveColor),
            if (label.isNotEmpty)
              CustomText(
                text: label,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isActive ? activeColor : inactiveColor,
                lineHeight: 1.1,
              ),
          ],
        ),
      ),
    );
  }
}
