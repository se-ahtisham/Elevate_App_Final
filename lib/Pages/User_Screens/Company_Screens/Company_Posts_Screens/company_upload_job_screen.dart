import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Drop_Down_Menu/custom_drop_down.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Posts_Screens/company_posted_jobs_screen.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*CompanyUploadJobScreen
└── Scaffold
    └── AnnotatedRegion
        └── Column
            ├── ElevateHeader
            └── Expanded
                └── Padding
                    └── SingleChildScrollView
                        └── Column
                            ├── CustomTextField (Job Title)
                            ├── SizedBox
                            ├── CustomTextField (Job Description)
                            ├── SizedBox
                            ├── CustomTextField (Required Skill)
                            ├── SizedBox
                            ├── CustomTextField (Experience Level)
                            ├── SizedBox
                            ├── CustomTextField (Salary Per Month)
                            ├── SizedBox
                            ├── CustomTextField (Benefits)
                            ├── SizedBox
                            ├── Row
                            │   ├── CustomText (JOB TYPE)
                            │   ├── SizedBox
                            │   └── CustomDropDown
                            ├── SizedBox
                            ├── Row
                            │   ├── CustomText (Work Mode)
                            │   ├── SizedBox
                            │   └── CustomDropDown
                            ├── SizedBox
                            ├── Row
                            │   ├── CustomText (Required Test)
                            │   ├── SizedBox
                            │   └── CustomDropDown
                            ├── SizedBox
                            ├── Row
                            │   ├── CustomText (Skill Badge)
                            │   ├── SizedBox
                            │   └── CustomDropDown
                            ├── SizedBox
                            └── TextButtonGradient (POST NOW) */

class CompanyUploadJobScreen extends StatefulWidget {
  const CompanyUploadJobScreen({super.key});

  @override
  State<CompanyUploadJobScreen> createState() => _CompanyUploadJobScreenState();
}

class _CompanyUploadJobScreenState extends State<CompanyUploadJobScreen> {
  late TextEditingController jobTitleController;
  late TextEditingController jobDescriptionController;
  late TextEditingController requiredSkillsController;
  late TextEditingController experienceLevelController;
  late TextEditingController benefitsController;
  late TextEditingController salaryController;

  // For Drop down
  String? jobTypeselectedValue;
  List<String> jobTypeoptions = ["Full Time", "Part-Time", "Intership"];
  String? workModeselectedValue;
  List<String> workModeoptions = ["Remote", "On-Site", "Hybrid"];
  String? testRequiredselectedValue;
  List<String> testRequiredoptions = ["Pure", "Vibe", "Experienced"];
  String? skillBadgeselectedValue;
  List<String> skillBadgeoptions = ["Level-1", "Level-2", "Level-3"];

  @override
  void initState() {
    super.initState();
    jobTitleController = TextEditingController();
    salaryController = TextEditingController();
    jobDescriptionController = TextEditingController();
    requiredSkillsController = TextEditingController();
    experienceLevelController = TextEditingController();
    benefitsController = TextEditingController();
  }

  @override
  void dispose() {
    jobTitleController.dispose();
    jobDescriptionController.dispose();
    requiredSkillsController.dispose();
    experienceLevelController.dispose();
    benefitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElevateColor.white,
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            ElevateHeader(
              title: "CREATING BEST",
              subTitle: "Oppoptunity For Others",
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextField(
                        hintText: "Job Title",
                        hintWeight: FontWeight.bold,
                        controller: jobTitleController,
                        cursorColor: ElevateColor.black,
                        underlineColor: ElevateColor.black,
                      ),
                      SizedBox(height: 30),

                      CustomTextField(
                        hintText: "Job Description",
                        hintWeight: FontWeight.bold,
                        controller: jobDescriptionController,
                        cursorColor: ElevateColor.black,
                        underlineColor: ElevateColor.black,
                      ),
                      SizedBox(height: 30),

                      CustomTextField(
                        hintText: "Required Skill",
                        hintWeight: FontWeight.bold,
                        controller: requiredSkillsController,
                        cursorColor: ElevateColor.black,
                        underlineColor: ElevateColor.black,
                      ),
                      SizedBox(height: 30),
                      CustomTextField(
                        hintText: "Experience Level",
                        hintWeight: FontWeight.bold,
                        controller: experienceLevelController,
                        cursorColor: ElevateColor.black,
                        underlineColor: ElevateColor.black,
                      ),
                      SizedBox(height: 30),
                      CustomTextField(
                        hintText: "Salary Per Month",
                        hintWeight: FontWeight.bold,
                        controller: salaryController,
                        cursorColor: ElevateColor.black,
                        underlineColor: ElevateColor.black,
                      ),

                      SizedBox(height: 30),
                      CustomTextField(
                        hintText: "Benefits",
                        hintWeight: FontWeight.bold,
                        controller: benefitsController,
                        cursorColor: ElevateColor.black,
                        underlineColor: ElevateColor.black,
                      ),

                      SizedBox(height: 30),
                      Row(
                        children: [
                          CustomText(
                            text: "JOB TYPE",
                            fontSize: 18,
                            color: const Color.fromARGB(255, 165, 165, 165),
                            fontWeight: FontWeight.w700,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(width: 79),
                          CustomDropDown(
                            hintText: "Full Time",
                            items: jobTypeoptions,
                            value: jobTypeselectedValue,
                            width: 200,
                            borderWidth: 0,
                            backgroundColor: const Color.fromARGB(
                              255,
                              235,
                              235,
                              235,
                            ),
                            onChanged: (value) {
                              setState(() {
                                jobTypeselectedValue = value;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          CustomText(
                            text: "Work Mode",
                            fontSize: 18,
                            color: const Color.fromARGB(255, 165, 165, 165),
                            fontWeight: FontWeight.w700,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(width: 56),
                          CustomDropDown(
                            hintText: "Remote",
                            items: workModeoptions,
                            value: workModeselectedValue,
                            width: 200,
                            borderWidth: 0,
                            backgroundColor: const Color.fromARGB(
                              255,
                              235,
                              235,
                              235,
                            ),
                            onChanged: (value) {
                              setState(() {
                                workModeselectedValue = value;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          CustomText(
                            text: "Required Test",
                            fontSize: 18,
                            color: const Color.fromARGB(255, 165, 165, 165),
                            fontWeight: FontWeight.w700,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(width: 32),
                          CustomDropDown(
                            hintText: "Pure",
                            items: testRequiredoptions,
                            value: testRequiredselectedValue,
                            width: 200,
                            borderWidth: 0,
                            backgroundColor: const Color.fromARGB(
                              255,
                              235,
                              235,
                              235,
                            ),
                            onChanged: (value) {
                              setState(() {
                                testRequiredselectedValue = value;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          CustomText(
                            text: "Skill Badge",
                            fontSize: 18,
                            color: const Color.fromARGB(255, 165, 165, 165),
                            fontWeight: FontWeight.w700,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(width: 58),
                          CustomDropDown(
                            hintText: "Level-1",
                            items: skillBadgeoptions,
                            value: skillBadgeselectedValue,
                            width: 200,
                            borderWidth: 0,
                            backgroundColor: const Color.fromARGB(
                              255,
                              235,
                              235,
                              235,
                            ),
                            onChanged: (value) {
                              setState(() {
                                skillBadgeselectedValue = value;
                              });
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 30),
                      TextButtonGradient(
                        text: "POST NOW",
                        height: 50,
                        textSize: 14,
                        textWeight: FontWeight.w400,
                        borderRadius: 50,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompanyPostedJobsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
