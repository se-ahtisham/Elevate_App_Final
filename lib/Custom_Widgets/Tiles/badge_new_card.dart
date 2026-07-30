import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:flutter/material.dart';

class BadgeNewCard extends StatelessWidget {
  final String? imagePath;
  final String buttonText;
  final VoidCallback onPickImage;
  final VoidCallback onButtonTap;

  final List<String>? levels;
  final String? selectedLevel;
  final ValueChanged<String?>? onLevelChanged;

  final List<String>? scoreRanges;
  final String? selectedScoreRange;
  final ValueChanged<String?>? onScoreRangeChanged;

  const BadgeNewCard({
    super.key,
    required this.imagePath,
    required this.buttonText,
    required this.onPickImage,
    required this.onButtonTap,
    this.levels,
    this.selectedLevel,
    this.onLevelChanged,
    this.scoreRanges,
    this.selectedScoreRange,
    this.onScoreRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onPickImage,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              backgroundImage: imagePath != null && imagePath!.isNotEmpty
                  ? NetworkImage(imagePath!)
                  : null,
              child: imagePath == null || imagePath!.isEmpty
                  ? const Icon(Icons.add, color: Colors.black, size: 30)
                  : null,
            ),
          ),

          const SizedBox(height: 25),

          // Detail fields only render when the caller supplies level options.
          if (levels != null) ...[
            // Badge Level
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(50),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: Colors.black,
                  iconEnabledColor: Colors.white,
                  hint: const Text(
                    "Badge Level",
                    style: TextStyle(color: Colors.white54),
                  ),
                  value: selectedLevel,
                  items: (levels ?? const []).map((level) {
                    return DropdownMenuItem<String>(
                      value: level,
                      child: Text(
                        level,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: onLevelChanged,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Required Score (range dropdown)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(50),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: Colors.black,
                  iconEnabledColor: Colors.white,
                  hint: const Text(
                    "Required Score",
                    style: TextStyle(color: Colors.white54),
                  ),
                  value: selectedScoreRange,
                  items: (scoreRanges ?? const ["50-60", "60-90", "90-100"])
                      .map((range) {
                        return DropdownMenuItem<String>(
                          value: range,
                          child: Text(
                            range,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      })
                      .toList(),
                  onChanged: onScoreRangeChanged,
                ),
              ),
            ),

            const SizedBox(height: 25),
          ] else
            const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onButtonTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: CustomText(
                text: buttonText,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
