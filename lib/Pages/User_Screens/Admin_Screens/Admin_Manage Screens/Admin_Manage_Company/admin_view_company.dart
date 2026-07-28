import "package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart";
import "package:elevate_app/Custom_Widgets/Header/elevate_header.dart";
import "package:elevate_app/Custom_Widgets/Text/custom_text.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart";
import "package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart";
import "package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class AdminViewCompany extends StatelessWidget {
  final CompanyModel company;

  const AdminViewCompany({super.key, required this.company});

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
                Stack(
                  children: [
                    ElevateHeader(
                      title: "Identity Center",
                      subTitle: "Account Control Center",
                    ),
                    Positioned(
                      top: 170,
                      right: 120,
                      child: TexxtButton(
                        text: "Back",
                        width: 120,
                        height: 50,
                        textSize: 12,
                        textWeight: FontWeight.w500,
                        textColor: const Color.fromARGB(255, 255, 255, 255),
                        backgroundColor: const Color.fromARGB(
                          224,
                          114,
                          114,
                          114,
                        ),
                        borderColor: const Color(0xFF8B8B8B),
                        borderRadius: 80,
                        borderWidth: 1,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 20),
                  child: UserDescription(
                    imageURL: company.logo.isNotEmpty
                        ? company.logo
                        : 'https://mir-s3-cdn-cf.behance.net/projects/404/e87f90243740647.Y3JvcCwxNTM0LDEyMDAsMzQsMA.jpg',
                    name: company.companyName,
                    shortDescription: company.industry.isNotEmpty
                        ? company.industry
                        : "Company",
                    skills: 0,
                    followers: company.followersCount,
                    followings: 0,
                    showSkills: false,
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
                      CustomText(
                        text: "ABOUT US",
                        fontSize: 20,
                        color: ElevateColor.lightgray,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        lineHeight: 1.0,
                      ),
                      const SizedBox(height: 12),
                      CustomText(
                        text: company.description.isNotEmpty
                            ? company.description
                            : "No description provided.",
                        fontSize: 13,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.justify,
                        lineHeight: 1.3,
                      ),
                      const SizedBox(height: 22),
                      UserSocialmedia(
                        city: company.location,
                        country: "",
                        email: company.email,
                        web: company.website,
                      ),

                      const SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Company Strengths",
                            fontSize: 20,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            text: company.companyStrengthList.isNotEmpty
                                ? company.companyStrengthList.join(" • ")
                                : "No strengths listed yet.",
                            fontSize: 12,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.left,
                            lineHeight: 1.2,
                          ),

                          const SizedBox(height: 30),
                          CustomText(
                            text: "Company Weaknesses",
                            fontSize: 20,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            text: company.companyWeaknessList.isNotEmpty
                                ? company.companyWeaknessList.join(" • ")
                                : "No weaknesses listed yet.",
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
