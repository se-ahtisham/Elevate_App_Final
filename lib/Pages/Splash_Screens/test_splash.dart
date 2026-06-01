import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Pages/Splash_Screens/ai_splash.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class TestSplash extends StatelessWidget {
  const TestSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Image takes remaining space
          Expanded(
            child: Image.asset(
              'lib/Resources/Images/Coding_Image.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Container(
            width: double.infinity,
            height: 300,
            color: ElevateColor.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: [
                // Small Line
                Container(
                  height: 5,
                  width: 80,
                  decoration: BoxDecoration(
                    color: ElevateColor.black,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                SizedBox(height: 30),

                // Main Text
                CustomText(
                  text: "Unleash Your Potential with Skill Testing",
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                  color: ElevateColor.black,
                  lineHeight: 1.1,
                ),
                SizedBox(height: 20),

                // Sub Text
                CustomText(
                  text:
                      "Elevator isn’t just about coding tests it’s a journey.",
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  textAlign: TextAlign.center,
                  color: ElevateColor.black,
                  lineHeight: 1.3,
                ),
                SizedBox(height: 30),

                // Button
                TextButtonGradient(
                  text: "Next",
                  width: 330,
                  height: 50,
                  borderRadius: 25,
               
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AiSplash()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
