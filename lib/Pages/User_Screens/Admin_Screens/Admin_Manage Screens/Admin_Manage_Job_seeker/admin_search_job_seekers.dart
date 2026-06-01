import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/experience_white_black_full.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*Scaffold
└── AnnotatedRegion<SystemUiOverlayStyle>
    └── Column
        ├── ElevateHeader
        │    ├── title: "Manage"
        │    └── subTitle: "Job Seekers"
        └── Expanded
            └── SingleChildScrollView
                    └── Column (crossAxisAlignment: start)
                        ├── CustomSearchBar
                        ├── SizedBox (height:260)
                        │   └── SingleChildScrollView
                        │       └── Column
                        │           ├── ExperienceWhiteBlackFull
                        ├── CustomText ("More For You")
                        └── SizedBox (height:260)
                            └── SingleChildScrollView
                                └── Column
                                    ├── ExperienceWhiteBlackFull */

class AdminSearchJobSeekers extends StatelessWidget {
  const AdminSearchJobSeekers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            ElevateHeader(
              title: "Manage",
              subTitle: "Job Seekers",
              titleSize: 40,
              subtitleSize: 25,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left: 30, right: 30, bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconText(
                      text: "Explore Profiles",
                      iconData: Icons.people_alt_outlined,
                      textSize: 20,
                      textWeight: FontWeight.bold,
                      iconSize: 25,
                      iconTextSpacing: 10,
                    ),
                    SizedBox(height: 15),
                    CustomSearchBar(
                      hintText: "Muhammad Ahtisham",
                      backgroundColor: ElevateColor.white,
                      width: 380,
                      height: 60,
                      textSize: 15,
                      iconSize: 30,
                    ),
                    SizedBox(height: 10),
                    // Single child view for search out profiles with 150 height
                    SizedBox(
                      height: 260,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            ExperienceWhiteBlackFull(
                              imageURL:
                                  "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                              name: "Muhaamad Ahtisham",
                              shortDescription: "Flutter Developer",
                              experience: "2-5 Experience",
                              firstContainerWidth: 270,
                              experienceBoxWidth: 240,
                              onTap: null,
                            ),
                            SizedBox(height: 10),
                            ExperienceWhiteBlackFull(
                              imageURL:
                                  "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                              name: "Muhaamad Ahtisham",
                              shortDescription: "Flutter Developer",
                              experience: "2-5 Experience",
                              firstContainerWidth: 270,
                              experienceBoxWidth: 240,
                              onTap: null,
                            ),
                            SizedBox(height: 10),
                            ExperienceWhiteBlackFull(
                              imageURL:
                                  "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                              name: "Muhaamad Ahtisham",
                              shortDescription: "Flutter Developer",
                              experience: "2-5 Experience",
                              firstContainerWidth: 270,
                              experienceBoxWidth: 240,
                              onTap: null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomText(
                      text: "More For You",
                      fontSize: 20,
                      color: ElevateColor.gray,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 10),

                    // Single child view for rest all Profile
                    SizedBox(
                      height: 260,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            ExperienceWhiteBlackFull(
                              imageURL:
                                  "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                              name: "Muhaamad Ahtisham",
                              shortDescription: "Flutter Developer",
                              experience: "2-5 Experience",
                              firstContainerWidth: 270,
                              experienceBoxWidth: 240,
                              onTap: null,
                            ),
                            SizedBox(height: 10),
                            ExperienceWhiteBlackFull(
                              imageURL:
                                  "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                              name: "Muhaamad Ahtisham",
                              shortDescription: "Flutter Developer",
                              experience: "2-5 Experience",
                              firstContainerWidth: 270,
                              experienceBoxWidth: 240,
                              onTap: null,
                            ),
                            SizedBox(height: 10),
                            ExperienceWhiteBlackFull(
                              imageURL:
                                  "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                              name: "Muhaamad Ahtisham",
                              shortDescription: "Flutter Developer",
                              experience: "2-5 Experience",
                              firstContainerWidth: 270,
                              experienceBoxWidth: 240,
                              onTap: null,
                            ),

                            SizedBox(height: 10),
                            ExperienceWhiteBlackFull(
                              imageURL:
                                  "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                              name: "Muhaamad Ahtisham",
                              shortDescription: "Flutter Developer",
                              experience: "2-5 Experience",
                              firstContainerWidth: 270,
                              experienceBoxWidth: 240,
                              onTap: null,
                            ),
                            SizedBox(height: 10),
                            ExperienceWhiteBlackFull(
                              imageURL:
                                  "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                              name: "Muhaamad Ahtisham",
                              shortDescription: "Flutter Developer",
                              experience: "2-5 Experience",
                              firstContainerWidth: 270,
                              experienceBoxWidth: 240,
                              onTap: null,
                            ),
                          ],
                        ),
                      ),
                    ),
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
