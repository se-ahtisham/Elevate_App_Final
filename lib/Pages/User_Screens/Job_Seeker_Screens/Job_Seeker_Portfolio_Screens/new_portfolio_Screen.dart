import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/contain_icon_text_button.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class NewPortfolioScreen extends StatelessWidget {
  const NewPortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          ElevateHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    const CustomText(
                      text: "UPLOAD IMAGES",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ElevateColor.lightgray,
                    ),

                    const SizedBox(height: 16),

                    // Image Upload Box
                    Container(
                      height: 120,
                      width: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAEAEA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Title Field
                    const CustomText(
                      text: "Title",
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 6),
                    const Divider(thickness: 1),

                    const SizedBox(height: 20),

                    // Description Field
                    const CustomText(
                      text: "Description",
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 6),
                    const Divider(thickness: 1),

                    const SizedBox(height: 25),

                    const CustomText(
                      text: "Files",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ElevateColor.lightgray,
                    ),

                    const SizedBox(height: 12),

                    // Add Files Button (YOUR WIDGET)
                    ContainIconTextButton(text: "Add Files", onTap: () {}),

                    const SizedBox(height: 40),

                    // ADD PROJECT BUTTON
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5A5A5A), Color(0xFF000000)],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const CustomText(
                          text: "ADD PROJECT",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Center(
                        child: CustomText(
                          text: "Back",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
