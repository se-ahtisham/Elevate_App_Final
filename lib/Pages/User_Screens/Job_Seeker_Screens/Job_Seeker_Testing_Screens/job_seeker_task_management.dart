import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/manage_white_black_full.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Testing_Screens/job_seeker_task_description_management.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*Jobseekertaskmanagement
└─ Scaffold
   └─ AnnotatedRegion<SystemUiOverlayStyle>
      └─ Column
         ├─ ElevateHeader
         │  ├─ title: "Elevate"
         │  └─ subTitle: "Task"
         │
         └─ Expanded
            └─ SingleChildScrollView
               └─ Column
                  ├─ Container (Create Task Card)
                  │  └─ Center
                  │     └─ Column
                  │        ├─ SizedBox
                  │        ├─ Padding
                  │        │  └─ CustomTextField (Task Title)
                  │        ├─ SizedBox
                  │        ├─ Padding
                  │        │  └─ CustomTextField (Task Description)
                  │        ├─ SizedBox
                  │        └─ TexxtButton ("Create Now")
                  │
                  ├─ SizedBox
                  │
                  ├─ CustomSearchBar ("Search Tasks")
                  │
                  └─ SizedBox (height: 250)
                     └─ SingleChildScrollView
                        └─ Column
                           ├─ SizedBox
                           ├─ ManageTitle (Java Test)
                           ├─ SizedBox
                           ├─ ManageTitle (Python Test)
                           ├─ SizedBox
                           └─ ManageTitle (Mobile App Test) */

class JobSeekerTaskManagement extends StatefulWidget {
  const JobSeekerTaskManagement({super.key});

  @override
  State<JobSeekerTaskManagement> createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<JobSeekerTaskManagement> {
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();

  @override
  void dispose() {
    taskTitleController.dispose();
    taskDescriptionController.dispose();
    super.dispose();
  }

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
              title: "Elevate",
              subTitle: "Task",
              titleSize: 40,
              subtitleSize: 25,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 380,
                      height: 240,
                      decoration: BoxDecoration(
                        gradient: ElevateGradientColors.grayToBlack,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(height: 25),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                              ),
                              child: CustomTextField(
                                controller: taskTitleController,
                                hintText: "Task Title",
                                cursorColor: const Color.fromARGB(
                                  255,
                                  255,
                                  255,
                                  255,
                                ),
                                underlineColor: const Color.fromARGB(
                                  255,
                                  214,
                                  214,
                                  214,
                                ),
                                textColor: ElevateColor.gray,
                                hintColor: const Color.fromARGB(
                                  255,
                                  214,
                                  214,
                                  214,
                                ),
                                hintWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                              ),
                              child: CustomTextField(
                                controller: taskDescriptionController,
                                hintText: "Task Description",
                                cursorColor: const Color.fromARGB(
                                  255,
                                  255,
                                  255,
                                  255,
                                ),
                                underlineColor: const Color.fromARGB(
                                  255,
                                  214,
                                  214,
                                  214,
                                ),
                                textColor: ElevateColor.gray,
                                hintColor: const Color.fromARGB(
                                  255,
                                  214,
                                  214,
                                  214,
                                ),
                                hintWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 40),
                            TexxtButton(
                              text: "Create Now",
                              height: 40,
                              width: 280,
                              textSize: 14,
                              textColor: ElevateColor.gray,
                              textWeight: FontWeight.bold,
                              borderRadius: 50,
                              backgroundColor: ElevateColor.white,
                              borderColor: ElevateColor.gray,
                              borderWidth: 0,
                              onTap: null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    CustomSearchBar(
                      hintText: "Search Tasks",
                      backgroundColor: ElevateColor.white,
                      width: 380,
                      height: 60,
                      textSize: 15,
                      iconSize: 30,
                    ),
                    SizedBox(
                      height: 250,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            ManageWhiteBlackFull(
                              titleText: 'Java Test',
                              subtitleText: 'Feedback',
                              firstContainerWidth: 240,
                              titleFontSize: 20,
                              subtitleFontSize: 16,
                              tileHeight: 90,
                              lineHeight: 1,
                              firstContainerColor: ElevateColor.white,

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        JobSeekerTaskDescriptionManagement(
                                          title: 'Java Test',
                                          suggestion:
                                              "Practice more coding problems and review these topics to strengthen your Java knowledge.",
                                          topicToImprove:
                                              "Object-Oriented Programming (Inheritance, Polymorphism, Encapsulation), Exception Handling, Java Collections (ArrayList, HashMap, HashSet), Problem Solving and Logic Building, Code Optimization",
                                        ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 15),
                            ManageWhiteBlackFull(
                              titleText: 'Python Test',
                              subtitleText: 'Feedback',
                              firstContainerWidth: 240,
                              titleFontSize: 20,
                              subtitleFontSize: 16,
                              tileHeight: 90,
                              lineHeight: 1,
                              firstContainerColor: ElevateColor.white,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        JobSeekerTaskDescriptionManagement(
                                          title: 'Python Test',
                                          suggestion:
                                              "Practice more coding problems and review these topics to strengthen your Java knowledge.",
                                          topicToImprove:
                                              "Object-Oriented Programming (Inheritance, Polymorphism, Encapsulation), Exception Handling, Java Collections (ArrayList, HashMap, HashSet), Problem Solving and Logic Building, Code Optimization",
                                        ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 15),
                            ManageWhiteBlackFull(
                              titleText: 'Mobile App Test',
                              subtitleText: 'Feedback',
                              firstContainerWidth: 240,
                              titleFontSize: 20,
                              subtitleFontSize: 16,
                              tileHeight: 90,
                              lineHeight: 1,
                              firstContainerColor: ElevateColor.white,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        JobSeekerTaskDescriptionManagement(
                                          title: 'Mobile App Test',
                                          suggestion:
                                              "Practice more coding problems and review these topics to strengthen your Java knowledge.",
                                          topicToImprove:
                                              "Object-Oriented Programming (Inheritance, Polymorphism, Encapsulation), Exception Handling, Java Collections (ArrayList, HashMap, HashSet), Problem Solving and Logic Building, Code Optimization",
                                        ),
                                  ),
                                );
                              },
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
