import "package:elevate_app/Custom_Widgets/Header/elevate_header.dart";
import "package:elevate_app/Custom_Widgets/Text/custom_text.dart";
import "package:elevate_app/Custom_Widgets/Text/icon_text.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart";
import "package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart";
import "package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class CompnayViewCompanyProfile extends StatelessWidget {
  final CompanyModel company;
  const CompnayViewCompanyProfile({super.key, required this.company});

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
                  title: "Company Profile",
                  subTitle: "Account Control Center",
                  showBackButton: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 20),
                  child: UserDescription(
                    imageURL: company.logo.isNotEmpty
                        ? company.logo
                        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(company.companyName.isNotEmpty ? company.companyName : "Company")}&background=E0E0E0&color=757575&size=128&bold=true',
                    name: company.companyName,
                    shortDescription: company.industry,
                    skills: company.activeJobs,
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
                      const SizedBox(height: 15),

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
                            : "No description available.",
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
                            text: "Company Achievements",
                            fontSize: 20,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          const SizedBox(height: 15),
                          if (company.achievementList.isEmpty)
                            CustomText(
                              text: "No achievements listed.",
                              fontSize: 12,
                              color: ElevateColor.whitegray,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.left,
                              lineHeight: 1.2,
                            )
                          else
                            ...company.achievementList.map(
                              (a) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: IconText(
                                  text: a,
                                  iconData: Icons.emoji_events_outlined,
                                  iconColor: ElevateColor.lightgray,
                                  iconSize: 30,
                                  iconTextSpacing: 8,
                                  textSize: 12,
                                  textColor: ElevateColor.lightgray,
                                  textWeight: FontWeight.w400,
                                  lineHeight: 1.2,
                                ),
                              ),
                            ),

                          const SizedBox(height: 30),
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
                                : "No strengths listed.",
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
                                : "No weaknesses listed.",
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
