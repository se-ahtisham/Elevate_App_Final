import "package:elevate_app/Custom_Widgets/Buttons/icon_text_button.dart";
import "package:elevate_app/Custom_Widgets/Header/elevate_header.dart";
import "package:elevate_app/Custom_Widgets/Text/custom_text.dart";
import "package:elevate_app/Custom_Widgets/Text/icon_text.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart";
import "package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/user_rating_company.dart";
import "package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

/*UserRequestRatingCompany
└── Scaffold (extendBodyBehindAppBar: true)
    └── AnnotatedRegion (SystemUiOverlayStyle.light)
        └── Container (height: infinity, color: white)
            └── SingleChildScrollView
                └── Column
                    ├── ElevateHeader
                    ├── Padding
                    │   └── UserDescription
                    └── Padding (vertical: 30, horizontal: 40)
                        └── Column (crossAxisAlignment: start)
                            ├── Row
                            │   ├── CustomText ("ABOUT US")
                            │   └── IconTextButton ("FEEDBACK")
                            │       └── Navigator.push → UserRatingCompany
                            ├── SizedBox
                            ├── CustomText (About description)
                            ├── SizedBox
                            ├── UserSocialmedia
                            ├── SizedBox
                            └── Column
                                ├── CustomText ("Company Achievements")
                                ├── SizedBox
                                ├── IconText (Achievements details)
                                ├── SizedBox
                                ├── CustomText ("Company Strengths")
                                ├── CustomText (Strengths text)
                                ├── SizedBox
                                ├── CustomText ("Company Weaknesses")
                                └── CustomText (Weaknesses text) */

class UserRequestRatingCompany extends StatelessWidget {
  const UserRequestRatingCompany({super.key});

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
                  title: "Explore Companies",
                  subTitle: "Explore roles from top companies",
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
                          SizedBox(width: 75),
                          IconTextButton(
                            text: "FEEDBACK",
                            iconTextSpacing: 10,
                            paddingLeft: 27,
                            paddingRight: 27,
                            iconData: Icons.emoji_emotions_outlined,
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
                                  builder: (context) => UserRatingCompany(),
                                ),
                              );
                            },
                          ),
                        ],
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
