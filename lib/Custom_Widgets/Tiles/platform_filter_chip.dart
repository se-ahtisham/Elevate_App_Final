import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:flutter/material.dart';

class PlatformFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const PlatformFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.black
              : const Color.fromARGB(95, 209, 209, 209),
          borderRadius: BorderRadius.circular(10),
        ),
        child: CustomText(
          text: label,

          color: isSelected
              ? const Color.fromARGB(255, 235, 235, 235)
              : Colors.black,
        ),
      ),
    );
  }
}
