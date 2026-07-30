import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:flutter/material.dart';

class SkillCard extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  final String startingSalary;
  final String endingSalary;

  const SkillCard({
    super.key,
    required this.title,
    required this.company,
    required this.location,
    required this.startingSalary,
    required this.endingSalary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            decoration: const BoxDecoration(
              gradient: ElevateGradientColors.grayToBlack,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.work_outline,
              color: Colors.white,
              size: 30,
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: title,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    // Fixed card height (150) leaves limited room;
                    // cap to 1 line so a long title can't wrap and
                    // squeeze the salary box out of the layout.
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    "$company • $location",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),

                  const SizedBox(height: 8),

                  // Previously a hardcoded width: 250, unrelated to
                  // the card's actual available width (the card
                  // itself has no fixed width — it's whatever the
                  // parent gives this Row). On narrower screens this
                  // would overflow horizontally. Using
                  // double.infinity with the Expanded ancestor lets
                  // it fill the available space instead, capped by a
                  // ConstrainedBox so it still looks like a compact
                  // pill rather than stretching edge-to-edge.
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Container(
                      width: double.infinity,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEDED),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CustomText(
                        text: "$startingSalary - $endingSalary Yearly",
                        fontSize: 12,
                        color: Colors.black54,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}