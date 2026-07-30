import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Text_background_box/custom_text_box.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class JobBlackTile extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  final String description;

  final String jobType;
  final String jobMode;
  final String salary;

  const JobBlackTile({
    super.key,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    this.jobType = "",
    this.jobMode = "",
    this.salary = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 200),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: ElevateGradientColors.grayToBlack,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: title,
              fontSize: 25,
              color: ElevateColor.white,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 2),

            CustomText(
              text: "$company • $location",
              fontSize: 15,
              color: const Color.fromARGB(255, 187, 187, 187),
              fontWeight: FontWeight.normal,
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 40,
              child: SingleChildScrollView(
                child: CustomText(
                  text: description,
                  fontSize: 11,
                  color: const Color.fromARGB(255, 187, 187, 187),
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 35,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (jobMode.isNotEmpty)
                      CustomTextBox(
                        text: jobMode,
                        backgroundColor: const Color.fromARGB(
                          92,
                          128,
                          128,
                          128,
                        ),
                        borderRadius: 50,
                        textColor: ElevateColor.white,
                        borderWidth: 0.8,
                        borderColor: const Color.fromARGB(255, 190, 190, 190),
                        paddingLeft: 20,
                        paddingRight: 20,
                        textSize: 10,
                        height: 30,
                      ),

                    if (jobMode.isNotEmpty) const SizedBox(width: 15),

                    if (jobType.isNotEmpty)
                      CustomTextBox(
                        text: jobType,
                        backgroundColor: const Color.fromARGB(
                          92,
                          128,
                          128,
                          128,
                        ),
                        borderRadius: 50,
                        textColor: ElevateColor.white,
                        borderWidth: 0.8,
                        borderColor: const Color.fromARGB(255, 190, 190, 190),
                        paddingLeft: 20,
                        paddingRight: 20,
                        textSize: 10,
                        height: 30,
                      ),

                    if (jobType.isNotEmpty) const SizedBox(width: 15),

                    if (salary.isNotEmpty)
                      CustomTextBox(
                        text: salary,
                        backgroundColor: const Color.fromARGB(
                          92,
                          128,
                          128,
                          128,
                        ),
                        borderRadius: 50,
                        textColor: ElevateColor.white,
                        borderWidth: 0.8,
                        borderColor: const Color.fromARGB(255, 190, 190, 190),
                        paddingLeft: 20,
                        paddingRight: 20,
                        textSize: 10,
                        height: 30,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
