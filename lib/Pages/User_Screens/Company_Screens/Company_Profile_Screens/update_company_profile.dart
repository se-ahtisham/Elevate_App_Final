import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateCompanyProfile extends StatefulWidget {
  const UpdateCompanyProfile({super.key});

  @override
  State<UpdateCompanyProfile> createState() => _UpdateCompanyProfileState();
}

class _UpdateCompanyProfileState extends State<UpdateCompanyProfile> {
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  static const _hintColor = Color(0xFF8E8E8E);
  static const _underlineColor = Color(0xFFE1E1E1);

  @override
  void dispose() {
    aboutController.dispose();
    locationController.dispose();
    emailController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            ElevateHeader(
              title: "Smarter Way to Grow",
              subTitle: "Your journey to success starts here",
              titleSize: 30,
              subtitleSize: 13,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 6),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      CustomTextField(
                        hintText: "About us",
                        hintWeight: FontWeight.w700,
                        hintColor: _hintColor,
                        controller: aboutController,
                        cursorColor: ElevateColor.gray,
                        underlineColor: _underlineColor,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                      ),

                      const SizedBox(height: 30),

                      CustomTextField(
                        hintText: "Location",
                        hintWeight: FontWeight.w700,
                        hintColor: _hintColor,
                        controller: locationController,
                        cursorColor: ElevateColor.gray,
                        underlineColor: _underlineColor,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                      ),

                      const SizedBox(height: 30),

                      CustomTextField(
                        hintText: "Email",
                        hintWeight: FontWeight.w700,
                        hintColor: _hintColor,
                        controller: emailController,
                        cursorColor: ElevateColor.gray,
                        underlineColor: _underlineColor,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                      ),

                      const SizedBox(height: 30),

                      CustomTextField(
                        hintText: "Website",
                        hintWeight: FontWeight.w700,
                        hintColor: _hintColor,
                        controller: websiteController,
                        cursorColor: ElevateColor.gray,
                        underlineColor: _underlineColor,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                      ),

                      const SizedBox(height: 30),

                      CustomText(
                        text: "Company Achievements",
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: ElevateColor.lightgray,
                        lineHeight: 1.0,
                        textAlign: TextAlign.left,
                      ),

                      const SizedBox(height: 12),

                      Container(
                        width: double.infinity,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 232, 232, 232),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: const Color.fromARGB(255, 210, 210, 210),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.emoji_events_outlined,
                              size: 18,
                              color: ElevateColor.lightgray,
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: CustomText(
                                text:
                                    "Best FinTech Startup 2024, ISO 27001 Certified",
                                fontSize: 11,
                                color: ElevateColor.lightgray,
                                fontWeight: FontWeight.w400,
                                lineHeight: 1.2,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        width: double.infinity,
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 240, 240, 240),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 230, 230, 230),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    210,
                                    210,
                                    210,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 14,
                                color: ElevateColor.lightgray,
                              ),
                            ),

                            const SizedBox(width: 10),

                            CustomText(
                              text: "Add More Achievements",
                              fontSize: 11,
                              color: _hintColor,
                              fontWeight: FontWeight.w500,
                              lineHeight: 1.0,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      TextButtonGradient(
                        text: "UPDATE NOW",
                        height: 50,
                        textSize: 12,
                        textWeight: FontWeight.w600,
                        borderRadius: 50,
                        borderColor: Colors.transparent,
                        borderWidth: 0,
                        width: double.infinity,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),

                      const SizedBox(height: 20),
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
