import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdminUpdateCompanyProfile extends StatefulWidget {
  const AdminUpdateCompanyProfile({super.key});

  @override
  State<AdminUpdateCompanyProfile> createState() =>
      _AdminUpdateCompanyProfileState();
}

class _AdminUpdateCompanyProfileState extends State<AdminUpdateCompanyProfile> {
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  final int currentIndex = 1; // "Manage" tab is selected

  final navItems = [
    {'icon': Icons.home_outlined, 'label': ''},
    {'icon': Icons.list_alt_rounded, 'label': 'Manage'},
    {'icon': Icons.person_outline_rounded, 'label': ''},
  ];

  @override
  void dispose() {
    _aboutController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Header & Avatar Overlap
            SizedBox(
              height: 250,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Dark Gradient Background
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: ElevateGradientColors.grayToBlack,
                    ),
                    padding: const EdgeInsets.only(left: 24, top: 60),
                    child: const CustomText(
                      text: "Elevate",
                      fontSize: 26,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  // Overlapping Avatar & Name
                  Positioned(
                    top:
                        120, // Center of avatar aligns with the edge (180 - 120/2 = 120)
                    left: 24,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Avatar
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF333333),
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          alignment: Alignment.center,
                          child: const CustomText(
                            text: "MS",
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Title Text
                        const Padding(
                          padding: EdgeInsets.only(
                            bottom: 24,
                          ), // Push it slightly down to align with the lower curve of avatar
                          child: CustomText(
                            text: "Tectzeee",
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1C1C3A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Form Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _aboutController,
                    hintText: "About us",
                    hintColor: const Color(0xFF6E6E6E),
                    hintWeight: FontWeight.w600,
                    fontSize: 12,
                    underlineColor: const Color(0xFFDCDCDC),
                    cursorColor: Colors.black,
                  ),
                  const SizedBox(height: 35),
                  CustomTextField(
                    controller: _locationController,
                    hintText: "Location",
                    hintColor: const Color(0xFF6E6E6E),
                    hintWeight: FontWeight.w600,
                    fontSize: 12,
                    underlineColor: const Color(0xFFDCDCDC),
                    cursorColor: Colors.black,
                  ),
                  const SizedBox(height: 35),
                  CustomTextField(
                    controller: _emailController,
                    hintText: "Email",
                    hintColor: const Color(0xFF6E6E6E),
                    hintWeight: FontWeight.w600,
                    fontSize: 12,
                    underlineColor: const Color(0xFFDCDCDC),
                    cursorColor: Colors.black,
                  ),
                  const SizedBox(height: 35),
                  CustomTextField(
                    controller: _websiteController,
                    hintText: "Website",
                    hintColor: const Color(0xFF6E6E6E),
                    hintWeight: FontWeight.w600,
                    fontSize: 12,
                    underlineColor: const Color(0xFFDCDCDC),
                    cursorColor: Colors.black,
                  ),

                  const SizedBox(height: 35),
                  // Company Achievements
                  const CustomText(
                    text: "Company Achievements",
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6E6E6E),
                  ),
                  const SizedBox(height: 15),

                  // Static Achievement Pill
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const CustomText(
                      text: "Best FinTech Startup 2024, ISO 27001 Certified",
                      color: Color(0xFF5A5A5A),
                      fontSize: 11,
                      textAlign: TextAlign.left,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 35),

                  // Add More Pill
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.add_circle_outline,
                          color: Color(0xFF7A7A7A),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        const CustomText(
                          text: "Add More Achievements",
                          color: Color(0xFF7A7A7A),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  // Action Buttons
                  TextButtonGradient(
                    text: "Update",
                    buttonBackgroundColor: ElevateGradientColors.grayToBlack,
                    width: double.infinity,
                    height: 50,
                    borderRadius: 12,
                    textSize: 14,
                    textWeight: FontWeight.w600,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 15),
                  TexxtButton(
                    text: "Cancel",
                    backgroundColor: Colors.white,
                    borderColor: ElevateColor.black,
                    borderWidth: 1.2,
                    textColor: ElevateColor.black,
                    width: double.infinity,
                    height: 50,
                    borderRadius: 12,
                    textSize: 14,
                    textWeight: FontWeight.w600,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating Bottom Navigation
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: ElevateColor.gray, width: 0.5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: List.generate(navItems.length, (i) {
              final item = navItems[i];
              bool selected = currentIndex == i;
              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedScale(
                      scale: selected ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        item['icon'] as IconData,
                        size: 20,
                        color: selected ? Colors.black : Colors.grey.shade400,
                      ),
                    ),
                    if (selected && item['label'] != "") ...[
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CustomText(
                          text: item['label'] as String,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
