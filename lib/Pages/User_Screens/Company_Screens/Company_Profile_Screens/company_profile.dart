import "package:cloud_firestore/cloud_firestore.dart";
import "package:elevate_app/Custom_Widgets/Buttons/icon_text_button.dart";
import "package:elevate_app/Custom_Widgets/Header/elevate_header.dart";
import "package:elevate_app/Custom_Widgets/Text/custom_text.dart";
import "package:elevate_app/Custom_Widgets/Text/icon_text.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart";
import "package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart";
import "package:elevate_app/Database/Online_Database/auth_service.dart";
import "package:elevate_app/Pages/User_Screens/Company_Screens/Company_Profile_Screens/update_company_profile.dart";
import "package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class CompanyProfile extends StatelessWidget {
  const CompanyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final String companyId = AuthService().currentUser?.uid ?? '';

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('companies').doc(companyId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("Company profile not found."));
            }

            final company = CompanyModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);

            return Container(
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
                        imageURL: company.logo.isNotEmpty
                            ? company.logo
                            : 'https://mir-s3-cdn-cf.behance.net/projects/404/e87f90243740647.Y3JvcCwxNTM0LDEyMDAsMzQsMA.jpg',
                        name: company.companyName,
                        shortDescription: company.industry,
                        skills: company.activeJobs,
                        followers: company.followersCount,
                        followings: 0,
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
                          Row(
                            children: [
                              CustomText(
                                text: "ABOUT US",
                                fontSize: 20,
                                color: ElevateColor.lightgray,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.left,
                                lineHeight: 1.0,
                              ),
                              const SizedBox(width: 75),
                              IconTextButton(
                                text: "UPDATE PROFILE",
                                iconTextSpacing: 5,
                                paddingLeft: 15,
                                paddingRight: 14,
                                iconData: Icons.settings,
                                backgroundColor: ElevateColor.white,
                                iconColor: ElevateColor.lightgray,
                                textColor: ElevateColor.gray,
                                textWeight: FontWeight.bold,
                                borderColor: ElevateColor.gray,
                                borderRadius: 50,
                                textSize: 10,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateCompanyProfile(company: company),
                                    ),
                                  );
                                },
                              ),
                            ],
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
                                ...company.achievementList.map((a) => Padding(
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
                                )),

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
            );
          },
        ),
      ),
    );
  }
}

