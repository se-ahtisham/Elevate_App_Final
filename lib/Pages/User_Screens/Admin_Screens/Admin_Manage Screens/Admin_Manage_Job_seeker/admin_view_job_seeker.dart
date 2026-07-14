import "package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart";
import "package:elevate_app/Custom_Widgets/Header/elevate_header.dart";
import "package:elevate_app/Custom_Widgets/Text/custom_text.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_education.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_work.dart";
import "package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart";
import "package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class AdminViewJobSeeker extends StatelessWidget {
  final JobSeekerModel jobSeeker;

  const AdminViewJobSeeker({super.key, required this.jobSeeker});

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
                    imageURL: jobSeeker.profilePic.isNotEmpty
                        ? jobSeeker.profilePic
                        : 'https://avatars.githubusercontent.com/u/159082885?v=4',
                    name: jobSeeker.name,
                    shortDescription: jobSeeker.about.isNotEmpty
                        ? jobSeeker.about
                        : "Job Seeker",
                    skills: jobSeeker.passedResultIDs.length,
                    followers: jobSeeker.followers.length,
                    followings: jobSeeker.following.length,
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
                        text: "ABOUT USER",
                        fontSize: 20,
                        color: ElevateColor.lightgray,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        lineHeight: 1.0,
                      ),
                      const SizedBox(height: 12),
                      CustomText(
                        text: jobSeeker.about.isNotEmpty
                            ? jobSeeker.about
                            : "No description provided.",
                        fontSize: 13,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.justify,
                        lineHeight: 1.3,
                      ),
                      const SizedBox(height: 22),
                      UserSocialmedia(
                        city: jobSeeker.location,
                        country: "",
                        email: jobSeeker.email,
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
                                text: jobSeeker.experienceLevel.isNotEmpty
                                    ? jobSeeker.experienceLevel
                                    : "Not specified",
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
                      if (jobSeeker.education.isEmpty)
                        CustomText(
                          text: "No education added yet.",
                          fontSize: 13,
                          color: ElevateColor.whitegray,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.left,
                        )
                      else
                        Column(
                          children: [
                            for (final edu in jobSeeker.education) ...[
                              UserEducation(
                                text: edu.title,
                                subText: "${edu.school} — ${edu.year}",
                                iconData: Icons.school_outlined,
                                iconSize: 25,
                              ),
                              const SizedBox(height: 15),
                            ],
                          ],
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
                      if (jobSeeker.jobExperience.isEmpty)
                        CustomText(
                          text: "No work experience added yet.",
                          fontSize: 13,
                          color: ElevateColor.whitegray,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.left,
                        )
                      else
                        Column(
                          children: [
                            for (final exp in jobSeeker.jobExperience) ...[
                              UserWork(
                                title: exp.jobTitle,
                                subtitle: exp.company,
                                iconData: Icons.person_outline,
                                startDate: exp.from,
                                endDate: exp.to.isEmpty ? null : exp.to,
                              ),
                              const SizedBox(height: 15),
                            ],
                          ],
                        ),
                      const SizedBox(height: 22),
                      TexxtButton(
                        text: "Back",
                        height: 50,
                        textSize: 14,
                        textWeight: FontWeight.w400,
                        textColor: Colors.black,
                        backgroundColor: Colors.transparent,
                        borderRadius: 50,
                        borderColor: Colors.black,
                        onTap: () => Navigator.pop(context),
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
