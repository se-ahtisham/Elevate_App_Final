import "package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart";
import "package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart";
import "package:elevate_app/Custom_Widgets/Header/elevate_header.dart";
import "package:elevate_app/Custom_Widgets/Text/custom_text.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_education.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_work.dart";
import "package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart";
import "package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/company_message_screen.dart";
import "package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/company_portfolio_check.dart";
import "package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/company_view_user_post.dart";
import "package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class CompanyViewProfile extends StatelessWidget {
  final JobSeekerModel seeker;
  const CompanyViewProfile({super.key, required this.seeker});

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
                const ElevateHeader(
                  title: "User Digital Identity",
                  subTitle: "Account Control Center",
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 20),
                  child: UserDescription(
                    imageURL: seeker.profilePic.isNotEmpty
                        ? seeker.profilePic
                        : 'https://avatars.githubusercontent.com/u/159082885?v=4',
                    name: seeker.name,
                    shortDescription: seeker.shortDescription,
                    skills: seeker.skillCount,
                    followers: seeker.followers.length,
                    followings: seeker.following.length,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TexxtButton(
                              text: "Message",
                              height: 40,
                              width: 80,
                              textSize: 14,
                              textColor: ElevateColor.gray,
                              textWeight: FontWeight.w400,
                              borderRadius: 50,
                              backgroundColor: Colors.transparent,
                              borderColor: ElevateColor.gray,
                              borderWidth: 1,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CompanyMessageScreen(
                                      receiverId: seeker.jobSeekerID,
                                      receiverName: seeker.name,
                                      receiverImage: seeker.profilePic,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      CustomText(
                        text: "ABOUT USER",
                        fontSize: 20,
                        color: ElevateColor.lightgray,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        lineHeight: 1.0,
                      ),
                      const SizedBox(height: 12),
                      CustomText(
                        text: seeker.about.isNotEmpty ? seeker.about : "No bio available.",
                        fontSize: 13,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.justify,
                        lineHeight: 1.3,
                      ),
                      const SizedBox(height: 22),
                      UserSocialmedia(
                        city: seeker.location,
                        country: "",
                        email: seeker.email,
                        phone: "",
                      ),

                      const SizedBox(height: 22),
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 233, 233),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: "EXPERIENCE LEVEL",
                                fontSize: 20,
                                color: ElevateColor.lightgray,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.left,
                                lineHeight: 1.0,
                              ),
                              const SizedBox(height: 8),
                              CustomText(
                                text: seeker.experienceLevel.isNotEmpty
                                    ? seeker.experienceLevel
                                    : "No experience listed",
                                fontSize: 12,
                                color: ElevateColor.lightgray,
                                fontWeight: FontWeight.w300,
                                textAlign: TextAlign.left,
                                lineHeight: 1.0,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),
                      CustomText(
                        text: "EDUCATION",
                        fontSize: 20,
                        color: ElevateColor.lightgray,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        lineHeight: 1.0,
                      ),
                      const SizedBox(height: 15),
                      Column(
                        children: seeker.education.isEmpty
                            ? [const Text("No education listed.")]
                            : seeker.education
                                .map((edu) => Padding(
                                      padding: const EdgeInsets.only(bottom: 15.0),
                                      child: UserEducation(
                                        text: edu.title,
                                        subText: edu.school,
                                        iconData: Icons.school_outlined,
                                        iconSize: 25,
                                      ),
                                    ))
                                .toList(),
                      ),

                      const SizedBox(height: 22),
                      CustomText(
                        text: "WORK",
                        fontSize: 20,
                        color: ElevateColor.lightgray,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        lineHeight: 1.0,
                      ),
                      const SizedBox(height: 15),
                      Column(
                        children: seeker.jobExperience.isEmpty
                            ? [const Text("No work experience listed.")]
                            : seeker.jobExperience
                                .map((exp) => Padding(
                                      padding: const EdgeInsets.only(bottom: 15.0),
                                      child: UserWork(
                                        title: exp.jobTitle,
                                        subtitle: exp.company,
                                        iconData: Icons.work_outline,
                                        startDate: exp.from,
                                        endDate: exp.to.isNotEmpty ? exp.to : "Present",
                                      ),
                                    ))
                                .toList(),
                      ),

                      const SizedBox(height: 40),
                      TextButtonGradient(
                        text: "View Portfolio",
                        height: 50,
                        textSize: 14,
                        textWeight: FontWeight.w400,
                        borderRadius: 50,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompanyPortfolioCheck(
                                jobSeekerID: seeker.jobSeekerID,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      TexxtButton(
                        text: "View Posts",
                        height: 50,
                        textSize: 14,
                        textColor: ElevateColor.gray,
                        textWeight: FontWeight.w400,
                        borderRadius: 50,
                        backgroundColor: Colors.transparent,
                        borderColor: ElevateColor.gray,
                        borderWidth: 1,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompanyViewUserPost(
                                authorID: seeker.jobSeekerID,
                              ),
                            ),
                          );
                        },
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
