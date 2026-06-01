// import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class PortfolioCard extends StatelessWidget {
  final String projectName;
  final String projectType;
  final String role;
  final String description;

  const PortfolioCard({
    super.key,
    required this.projectName,
    required this.projectType,
    required this.role,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        // height: 175,
        width: 300,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ElevateColor.lightgray,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: ElevateColor.black,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Project name + Role
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    text: projectName,
                    fontSize: 22,
                    color: ElevateColor.white,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    role,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),
            Text(
              projectType,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),

            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 12, color: Colors.white54),
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("MORE DETAILS"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
