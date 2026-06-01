import "package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart";
import "package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart";
import "package:elevate_app/Custom_Widgets/Header/elevate_header.dart";
import "package:elevate_app/Custom_Widgets/Text/custom_text.dart";
import "package:elevate_app/Custom_Widgets/Text/icon_text.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart";
import "package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class AdminDeleteCompany extends StatelessWidget {
  const AdminDeleteCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ElevateHeader(
                  title: "Your Digital Identity",
                  subTitle: "Account Control Center",
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 20),
                  child: UserDescription(
                    imageURL:
                        'https://mir-s3-cdn-cf.behance.net/projects/404/e87f90243740647.Y3JvcCwxNTM0LDEyMDAsMzQsMA.jpg',
                    name: "TechNova Inc.",
                    shortDescription: "FinTech",
                    skills: 10,
                    followers: 238,
                    followings: 101,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    
                      TextButtonGradient(
                        text: "Delete Company",
                        height: 50,
                        textSize: 14,
                        textWeight: FontWeight.w400,
                        borderRadius: 50,
                         onTap: () {
    Navigator.pop(context);
  },
                      ),
                      const SizedBox(height: 35),

                      CustomText(
                        text: "ABOUT US",
                        fontSize: 20,
                        color: ElevateColor.lightgray,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        lineHeight: 1.0,
                      ),
                      SizedBox(height: 12),
                      CustomText(
                        text:
                            "TechNova Inc. is dedicated to building secure and user-friendly financial platforms. We foster a culture of collaboration, innovation, and continuous learning.",
                        fontSize: 13,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.justify,
                        lineHeight: 1.3,
                      ),
                      SizedBox(height: 22),
                      UserSocialmedia(
                        city: "Lahore",
                        country: "Pakistan",
                        email: "technova@gmail.com",
                        web: "www.technova.com",
                      ),

                      SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Company Achievements",
                            fontSize: 20,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          SizedBox(height: 15),
                          IconText(
                            text:
                                "Best FinTech Startup 2024, ISO 27001 Certified",
                            iconData: Icons.emoji_events_outlined,
                            iconColor: ElevateColor.lightgray,
                            iconSize: 30,
                            iconTextSpacing: 8,
                            textSize: 12,
                            textColor: ElevateColor.lightgray,
                            textWeight: FontWeight.w400,
                            lineHeight: 1.2,
                          ),
                          SizedBox(height: 30),
                          CustomText(
                            text: "Company Strengths",
                            fontSize: 20,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          SizedBox(height: 8),
                          CustomText(
                            text:
                                "Innovation • Collaboration • Supportive Management • Career Growth • Learning Opportunities",
                            fontSize: 12,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.left,
                            lineHeight: 1.2,
                          ),

                          SizedBox(height: 30),
                          CustomText(
                            text: "Company Weaknesses",
                            fontSize: 20,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          SizedBox(height: 8),
                          CustomText(
                            text:
                                "High Workload • Tight Deadlines • Bureaucracy • Limited Benefits • Poor Documentation",
                            fontSize: 12,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.left,
                            lineHeight: 1.2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
