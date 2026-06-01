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
                  ),

                  Text(
                    "$company • $location",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    width: 250,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDEDED),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomText(
                      text: "$startingSalary - $endingSalary" + " Yearly",
                      fontSize: 12,
                      color: Colors.black54,
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
