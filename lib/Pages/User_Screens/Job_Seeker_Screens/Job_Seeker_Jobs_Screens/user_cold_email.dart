import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserColdEmail extends StatelessWidget {
  final String jobTitle;
  final String companyName;

  const UserColdEmail({
    super.key,
    this.jobTitle = "UI/UX Designer",
    this.companyName = "Microsoft",
  });

  @override
  Widget build(BuildContext context) {
    final emailBody =
        "Thank you for reaching out and considering me for the $jobTitle position at $companyName. I appreciate you sharing the details of the role and I am very excited about the opportunity to contribute to your team.\nWith my experience in designing user-friendly interfaces and creating seamless user experiences for both web and mobile applications, I am confident in my ability to add value to your projects. I have worked extensively with tools like Figma, Adobe XD, and Sketch, and I am passionate about user-centered design, wireframing, prototyping, and conducting usability research.\nI would love to learn more about your team, current projects, and how I can support your vision.";

    return Scaffold(
      backgroundColor: ElevateColor.white,
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ElevateHeader(
              title: "Opportunities",
              subTitle: "Powered by AI",
              titleSize: 25,
              subtitleSize: 20,
              showBackButton: true,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    CustomText(
                      text: "Join Our Team as a $jobTitle",
                      fontSize: 19,
                      color: const Color.fromARGB(255, 99, 99, 99),
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      lineHeight: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    CustomText(
                      text: emailBody,
                      fontSize: 12,
                      color: const Color.fromARGB(255, 99, 99, 99),
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.left,
                      lineHeight: 1.5,
                    ),
                    const SizedBox(height: 40),
                    TextButtonGradient(
                      text: "Save",
                      height: 50,
                      textSize: 14,
                      textWeight: FontWeight.w400,
                      borderRadius: 50,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 15),
                    TexxtButton(
                      text: "Back",
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
                    const SizedBox(height: 30),
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
