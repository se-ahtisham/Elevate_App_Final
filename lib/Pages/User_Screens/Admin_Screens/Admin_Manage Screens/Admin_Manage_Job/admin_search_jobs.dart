import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_white_black_full_tile.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Job/admin_delete_jobs.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/admin_manage.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*Scaffold
├─ AnnotatedRegion<SystemUiOverlayStyle>
│  └─ Column
│     ├─ ElevateHeader
│     │    ├─ title: "Manage"
│     │    └─ subTitle: "Jobs"
│     └─ Expanded
│        └─ SingleChildScrollView
│           └─ Column (padding: left 30, right 30, bottom 50)
│              ├─ IconText ("Explore Jobs" + icon)
│              ├─ SizedBox(height: 15)
│              ├─ CustomSearchBar
│              ├─ SizedBox(height: 10)
│              ├─ SizedBox(height: 260)
│              │    └─ SingleChildScrollView
│              │         └─ Column
│              │             ├─ jobWhiteBlackFullTile (Senior Flutter Developer)
│              │             ├─ SizedBox(height: 10)
│              │             ├─ jobWhiteBlackFullTile (...)
│              │             └─ jobWhiteBlackFullTile (...)
│              ├─ SizedBox(height: 10)
│              ├─ CustomText ("More For You")
│              ├─ SizedBox(height: 10)
│              └─ SizedBox(height: 260)
│                   └─ SingleChildScrollView
│                        └─ Column
│                            ├─ jobWhiteBlackFullTile (...)
│                            ├─ SizedBox(height: 10)
│                            ├─ jobWhiteBlackFullTile (...)
│                            └─ jobWhiteBlackFullTile (...) */

class AdminSearchJobs extends StatelessWidget {
  const AdminSearchJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            Stack(
              children: [
                Stack(
                  children: [
                    ElevateHeader(
                      title: "Manage",
                      subTitle: "Jobs",
                      titleSize: 40,
                      subtitleSize: 25,
                    ),
Padding(
  padding: const EdgeInsets.only(left: 250.0, top: 170),
  child: TextButtonGradient(
              text: "Dashboard",
              height: 50,
              width: 150,
              borderRadius: 25,
              buttonBackgroundColor: ElevateGradientColors.white,
              textColor: Colors.black,
              onTap: () {
Navigator.push( context, MaterialPageRoute( builder: (context) => AdminManage(), ),);
},
            ),
),


                  ],
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left: 30, right: 30, bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconText(
                      text: "Explore Jobs",
                      iconData: Icons.people_alt_outlined,
                      textSize: 20,
                      textWeight: FontWeight.bold,
                      iconSize: 25,
                      iconTextSpacing: 10,
                    ),
                    SizedBox(height: 15),
                    CustomSearchBar(
                      hintText: "Search Job",
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
                            JobWhiteBlackFullTile(
                              titleText: "Senior Flutter Developer",
                              subtitleText: "Experience: 3-5 years",
                              jobTypeText: "Full-Time",
                              jobModeText: "Remote",
                              salaryText: "\$60k - \$80k",
                              tileHeight: 120,
                              blockFontSize: 9,
                              firstContainerWidth: 280,
                              secondContainerWidth: 70,
                              smallBoxWdith: 80,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminDeleteJobs(
                                      title: "Senior Flutter Developer",
                                      description:
                                          """Required experience in designing user-friendly interfaces and creating seamless user experiences for both web and mobile applications, I am confident in my ability to add value to your projects. I have worked extensively with tools like Figma, Adobe XD, and Sketch, and I am passionate about user-centered design, wireframing, prototyping, and conducting usability research""",
                                    ),
                                  ),
                                );
                              },
                              sizedBetween: 3,
                              spaceBetweenSubtitleBlocks: 20,
                              spaceBetweenTitleSubtitle: 10,
                            ),
                            SizedBox(height: 10),
                            JobWhiteBlackFullTile(
                              titleText: "Senior Flutter Developer",
                              subtitleText: "Experience: 3-5 years",
                              jobTypeText: "Full-Time",
                              jobModeText: "Remote",
                              salaryText: "\$60k - \$80k",
                              tileHeight: 120,
                              blockFontSize: 9,
                              firstContainerWidth: 280,
                              secondContainerWidth: 70,
                              smallBoxWdith: 80,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminDeleteJobs(
                                      title: "Senior Flutter Developer",
                                      description:
                                          """Required experience in designing user-friendly interfaces and creating seamless user experiences for both web and mobile applications, I am confident in my ability to add value to your projects. I have worked extensively with tools like Figma, Adobe XD, and Sketch, and I am passionate about user-centered design, wireframing, prototyping, and conducting usability research""",
                                    ),
                                  ),
                                );
                              },
                              sizedBetween: 3,
                              spaceBetweenSubtitleBlocks: 20,
                              spaceBetweenTitleSubtitle: 10,
                            ),
                            SizedBox(height: 10),
                            JobWhiteBlackFullTile(
                              titleText: "Senior Flutter Developer",
                              subtitleText: "Experience: 3-5 years",
                              jobTypeText: "Full-Time",
                              jobModeText: "Remote",
                              salaryText: "\$60k - \$80k",
                              tileHeight: 120,
                              blockFontSize: 9,
                              firstContainerWidth: 280,
                              secondContainerWidth: 70,
                              smallBoxWdith: 80,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminDeleteJobs(
                                      title: "Senior Flutter Developer",
                                      description:
                                          """Required experience in designing user-friendly interfaces and creating seamless user experiences for both web and mobile applications, I am confident in my ability to add value to your projects. I have worked extensively with tools like Figma, Adobe XD, and Sketch, and I am passionate about user-centered design, wireframing, prototyping, and conducting usability research""",
                                    ),
                                  ),
                                );
                              },
                              sizedBetween: 3,
                              spaceBetweenSubtitleBlocks: 20,
                              spaceBetweenTitleSubtitle: 10,
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
                            JobWhiteBlackFullTile(
                              titleText: "Senior Flutter Developer",
                              subtitleText: "Experience: 3-5 years",
                              jobTypeText: "Full-Time",
                              jobModeText: "Remote",
                              salaryText: "\$60k - \$80k",
                              tileHeight: 120,
                              blockFontSize: 9,
                              firstContainerWidth: 280,
                              secondContainerWidth: 70,
                              smallBoxWdith: 80,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminDeleteJobs(
                                      title: "Senior Flutter Developer",
                                      description:
                                          """Required experience in designing user-friendly interfaces and creating seamless user experiences for both web and mobile applications, I am confident in my ability to add value to your projects. I have worked extensively with tools like Figma, Adobe XD, and Sketch, and I am passionate about user-centered design, wireframing, prototyping, and conducting usability research""",
                                    ),
                                  ),
                                );
                              },
                              sizedBetween: 3,
                              spaceBetweenSubtitleBlocks: 20,
                              spaceBetweenTitleSubtitle: 10,
                            ),
                            SizedBox(height: 10),
                            JobWhiteBlackFullTile(
                              titleText: "Senior Flutter Developer",
                              subtitleText: "Experience: 3-5 years",
                              jobTypeText: "Full-Time",
                              jobModeText: "Remote",
                              salaryText: "\$60k - \$80k",
                              tileHeight: 120,
                              blockFontSize: 9,
                              firstContainerWidth: 280,
                              secondContainerWidth: 70,
                              smallBoxWdith: 80,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminDeleteJobs(
                                      title: "Senior Flutter Developer",
                                      description:
                                          """Required experience in designing user-friendly interfaces and creating seamless user experiences for both web and mobile applications, I am confident in my ability to add value to your projects. I have worked extensively with tools like Figma, Adobe XD, and Sketch, and I am passionate about user-centered design, wireframing, prototyping, and conducting usability research""",
                                    ),
                                  ),
                                );
                              },
                              sizedBetween: 3,
                              spaceBetweenSubtitleBlocks: 20,
                              spaceBetweenTitleSubtitle: 10,
                            ),
                            SizedBox(height: 10),
                            JobWhiteBlackFullTile(
                              titleText: "Senior Flutter Developer",
                              subtitleText: "Experience: 3-5 years",
                              jobTypeText: "Full-Time",
                              jobModeText: "Remote",
                              salaryText: "\$60k - \$80k",
                              tileHeight: 120,
                              blockFontSize: 9,
                              firstContainerWidth: 280,
                              secondContainerWidth: 70,
                              smallBoxWdith: 80,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminDeleteJobs(
                                      title: "Senior Flutter Developer",
                                      description:
                                          """Required experience in designing user-friendly interfaces and creating seamless user experiences for both web and mobile applications, I am confident in my ability to add value to your projects. I have worked extensively with tools like Figma, Adobe XD, and Sketch, and I am passionate about user-centered design, wireframing, prototyping, and conducting usability research""",
                                    ),
                                  ),
                                );
                              },
                              sizedBetween: 3,
                              spaceBetweenSubtitleBlocks: 20,
                              spaceBetweenTitleSubtitle: 10,
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
