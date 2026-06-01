import "package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart";
import "package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart";
import "package:elevate_app/Custom_Widgets/Header/elevate_header.dart";
import "package:elevate_app/Custom_Widgets/Text/custom_text.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_education.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_skill.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_work.dart";
import "package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class JobSeekerViewProfileScreen extends StatelessWidget {
  const JobSeekerViewProfileScreen({super.key});

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
                        'https://avatars.githubusercontent.com/u/159082885?v=4',
                    name: "Muhammad Ahtisham",
                    shortDescription: "Backend Developer",
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
                      Row(
                        children: [
                          TextButtonGradient(
                            text: "Follow",
                            height: 40,
                            width: 160,
                            textSize: 14,
                            textWeight: FontWeight.w400,
                            borderRadius: 50,
                            onTap: null,
                          ),
                          SizedBox(width: 20),
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
                              onTap: null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      CustomText(
                        text: "ABOUT ME",
                        fontSize: 20,
                        color: ElevateColor.lightgray,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        lineHeight: 1.0,
                      ),
                      SizedBox(height: 12),
                      CustomText(
                        text:
                            "I’m web designer, I work in programs like figma, adobe photoshop, adobe illustratoI’m web designer, I work in programs like figma, adobe photoshop, adobe illustrator",
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
                        email: "se.ahtisham@gmail.com",
                        phone: "03000000000",
                      ),

                      SizedBox(height: 22),
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
                              SizedBox(height: 8),
                              CustomText(
                                text: "3-5 Year Experience",
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

                      SizedBox(height: 22),
                      CustomText(
                        text: "EDUCATION",
                        fontSize: 20,
                        color: ElevateColor.lightgray,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        lineHeight: 1.0,
                      ),

                      SizedBox(height: 15),
                      Column(
                        children: [
                          UserEducation(
                            text: 'Matriculation in Computer Science',
                            subText: 'Milli Foundation High School, lahore',
                            iconData: Icons.backpack_outlined,
                            iconSize: 25,
                          ),
                          SizedBox(height: 15),
                          UserEducation(
                            text: 'Intermediate of Computer Science',
                            subText: 'Govt. Shalimar college, lahore',
                            iconData: Icons.book_outlined,
                            iconSize: 25,
                          ),
                          SizedBox(height: 15),
                          UserEducation(
                            text: 'Bachelor of Software Engineering',
                            subText: 'University of Management and Technology ',
                            iconData: Icons.school_outlined,
                            iconSize: 25,
                          ),
                        ],
                      ),
                      SizedBox(height: 22),
                      CustomText(
                        text: "SKILL",
                        fontSize: 20,
                        color: ElevateColor.lightgray,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        lineHeight: 1.0,
                      ),

                      SizedBox(height: 15),
                      Column(
                        children: [
                          UserSkill(
                            title: 'Java Development',
                            subtitle: 'Experienced Coding',
                            imagePath:
                                'lib/Resources/Images/Coding_Badges/Pure/pure_hard.png',
                            year: '2025',
                          ),

                          SizedBox(height: 15),
                          UserSkill(
                            title: 'Python',
                            subtitle: 'Experienced Coding',
                            imagePath:
                                'lib/Resources/Images/Coding_Badges/Vibe/vibe_hard.png',
                            year: '2025',
                          ),
                        ],
                      ),
                      SizedBox(height: 22),
                      CustomText(
                        text: "WORK",
                        fontSize: 20,
                        color: ElevateColor.lightgray,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        lineHeight: 1.0,
                      ),

                      SizedBox(height: 15),
                      Column(
                        children: [
                          UserWork(
                            title: 'Junior Software Engineer',
                            subtitle: 'Devsinc, Lahore Pakistan',
                            iconData: Icons.person_outline,
                            startDate: "2022",
                            endDate: null, // Current Job
                          ),

                          SizedBox(height: 15),

                          UserWork(
                            title: 'Junior Software Engineer',
                            subtitle: 'Devsinc, Lahore Pakistan',
                            iconData: Icons.person_outline,
                            startDate: "2022",
                            endDate: "2026",
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
