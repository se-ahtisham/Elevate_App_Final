import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminUpdateBadge extends StatelessWidget {
  const AdminUpdateBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            Stack(
              children: [
                ElevateHeader(
                  title: "Elevate",
                  subTitle: "Badges",
                  titleSize: 18,
                  subtitleSize: 28,
                ),
                const Positioned(
                  top: 8,
                  left: 18,
                  child: SafeArea(
                    bottom: false,
                    child: CustomText(
                      text: "Elevate",
                      fontSize: 22,
                      color: ElevateColor.white,
                      fontWeight: FontWeight.w700,
                      lineHeight: 1.0,
                    ),
                  ),
                ),
              ],
            ),

            // BODY (FIXED OVERFLOW HERE)
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF4F4F4),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 4),

                      const CustomText(
                        text: "OLD BADGE IMAGE",
                        fontSize: 20,
                        color: ElevateColor.gray,
                        fontWeight: FontWeight.w400,
                        lineHeight: 1.0,
                      ),

                      const SizedBox(height: 16),

                      Image.asset(
                        'lib/Resources/Images/Coding_Badges/Pure/pure_medium.png',
                        width: 92,
                        height: 92,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 18),

                      const CustomText(
                        text: "NEW BADGE IMAGE",
                        fontSize: 20,
                        color: ElevateColor.gray,
                        fontWeight: FontWeight.w400,
                        lineHeight: 1.0,
                      ),

                      const SizedBox(height: 14),

                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          customBorder: const CircleBorder(),
                          child: Container(
                            width: 124,
                            height: 124,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F3F3),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                                width: 1.5,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x22000000),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 60,
                              color: Color(0xFFB8B8B8),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      TextButtonGradient(
                        text: "Update Badge",
                        width: double.infinity,
                        height: 38,
                        borderRadius: 11,
                        textSize: 13,
                        textWeight: FontWeight.w600,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),

                      const SizedBox(height: 10),

                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 38),
                          side: const BorderSide(
                            color: Color(0xFF808080),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                          backgroundColor: Colors.transparent,
                          foregroundColor: ElevateColor.gray,
                        ),
                        child: const CustomText(
                          text: "Cancel",
                          fontSize: 13,
                          color: ElevateColor.gray,
                          fontWeight: FontWeight.w500,
                          lineHeight: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}