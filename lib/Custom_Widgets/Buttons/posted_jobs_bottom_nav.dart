import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:flutter/material.dart';

class PostedJobsBottomNav extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int>? onTap;

  const PostedJobsBottomNav({super.key, this.activeIndex = 1, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFF7F7F7),
        border: Border(top: BorderSide(color: Color(0xFFE7E7E7))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(0, Icons.shopping_bag_outlined, ''),
          _item(1, Icons.insights_rounded, 'Posts'),
          _item(2, Icons.search_rounded, ''),
          _item(3, Icons.corporate_fare_outlined, ''),
          _item(4, Icons.person_outline_rounded, ''),
        ],
      ),
    );
  }

  Widget _item(int index, IconData icon, String label) {
    final bool isActive = activeIndex == index;
    const active = Color(0xFFE12EE5);
    const inactive = Color(0xFF4D4D4D);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => onTap?.call(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: isActive ? active : inactive),
            if (label.isNotEmpty)
              CustomText(
                text: label,
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: isActive ? active : inactive,
                lineHeight: 1.0,
              ),
          ],
        ),
      ),
    );
  }
}
