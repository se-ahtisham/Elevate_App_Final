import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VibeCoding extends StatelessWidget {
  const VibeCoding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElevateColor.white,
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevateHeader(
              title: "Vibe Coding Test",
              subTitle: "AI‑Interactive Guided Coding",
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0),
              child: Row(
                children: [
                  Image.asset(
                    "lib/Resources/Images/Coding_Badges/Experienced/experience_easy.png",
                    width: 120,
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: CustomText(
                      text: "PREVIOUS BADGE",
                      fontSize: 19,
                      color: const Color.fromARGB(255, 99, 99, 99),
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.justify,
                      maxLines: 2,
                      lineHeight: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "RULES",
                    fontSize: 19,
                    color: const Color.fromARGB(255, 99, 99, 99),
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.justify,
                    maxLines: 2,
                    lineHeight: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 20),
                  CustomText(
                    text: """Timed coding test. Remaining time shown on screen.
• Opening any external website is not allowed.
• If you close the test window, the test will automatically terminate.
• If you minimize the window, the test will automatically terminate.
• Once submitted, the test cannot be retaken immediately.
• Any attempt to cheat results in test cancellation.""",
                    fontSize: 12,
                    color: const Color.fromARGB(255, 99, 99, 99),
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.left,
                    lineHeight: 1.5,
                  ),
                  SizedBox(height: 40),
                  TextButtonGradient(
                    text: "Accept & Start",
                    height: 50,
                    textSize: 14,
                    textWeight: FontWeight.w400,
                    borderRadius: 50,
                    onTap: null,
                  ),
                  SizedBox(height: 15),
                  TexxtButton(
                    text: "Cancel",
                    height: 50,
                    textSize: 14,
                    textColor: ElevateColor.gray,
                    textWeight: FontWeight.w400,
                    borderRadius: 50,
                    backgroundColor: Colors.transparent,
                    borderColor: ElevateColor.gray,
                    borderWidth: 1,
                     onTap: () {
    Navigator.pop(context);
  },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
