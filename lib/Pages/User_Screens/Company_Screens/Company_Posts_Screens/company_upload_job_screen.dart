import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Drop_Down_Menu/custom_drop_down.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Database/Online_Database/auth_service.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Posts_Screens/company_posted_jobs_screen.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  late TextEditingController salaryMinController;
  late TextEditingController salaryMaxController;
  late TextEditingController locationController;

  // For Drop down
  String? jobTypeselectedValue = "Full Time";
  List<String> jobTypeoptions = ["Full Time", "Part-Time", "Internship"];
  String? workModeselectedValue = "Remote";
  List<String> workModeoptions = ["Remote", "On-Site", "Hybrid"];
  String? testRequiredselectedValue = "Pure";
  List<String> testRequiredoptions = ["Pure", "Vibe", "Experienced"];
  String? skillBadgeselectedValue = "Bronze";
  List<String> skillBadgeoptions = ["Bronze", "Silver", "Gold"];

  final AuthService _authService = AuthService();
  bool isPosting = false;

  @override
  void initState() {
    super.initState();
    jobTitleController = TextEditingController();
    salaryMinController = TextEditingController();
    salaryMaxController = TextEditingController();
    jobDescriptionController = TextEditingController();
    requiredSkillsController = TextEditingController();
    experienceLevelController = TextEditingController();
    benefitsController = TextEditingController();
    locationController = TextEditingController();
  }

  @override
  void dispose() {
    jobTitleController.dispose();
    jobDescriptionController.dispose();
    requiredSkillsController.dispose();
    experienceLevelController.dispose();
    benefitsController.dispose();
    salaryMinController.dispose();
    salaryMaxController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> _postJob() async {
    final isInvalid =
        jobTitleController.text.trim().isEmpty ||
        jobDescriptionController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty ||
        salaryMinController.text.trim().isEmpty ||
        salaryMaxController.text.trim().isEmpty;

    if (isInvalid) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please fill all required fields (title, description, location, salary).',
            ),
          ),
        );
      }
      return;
    }

    setState(() {
      isPosting = true;
    });

    try {
      final String companyId = _authService.currentUser?.uid ?? '';
      final docRef = FirebaseFirestore.instance.collection('jobs').doc();

      final jobPost = JobPostModel(
        jobID: docRef.id,
        companyID: companyId,
        title: jobTitleController.text.trim(),
        description: jobDescriptionController.text.trim(),
        requiredSkills: requiredSkillsController.text
            .trim()
            .split(',')
            .map((e) => e.trim())
            .toList(),
        requiredBadges: [skillBadgeselectedValue ?? ''],
        salary:
            '${salaryMinController.text.trim()} - ${salaryMaxController.text.trim()} PKR/month',
        jobType: jobTypeselectedValue ?? 'Full Time',
        location: locationController.text.trim(),
        experienceLevel: experienceLevelController.text.trim(),
        postedAt: DateTime.now(),
      );

      await docRef.set(jobPost.toMap());

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          isPosting = false;
        });
      }
    }
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
              subTitle: "Opportunity For Others",
              showBackButton: true,
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
                        hintText: "Location",
                        hintWeight: FontWeight.bold,
                        controller: locationController,
                        cursorColor: ElevateColor.black,
                        underlineColor: ElevateColor.black,
                      ),
                      SizedBox(height: 30),

                      CustomTextField(
                        hintText: "Required Skill (comma separated)",
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
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: "Min Salary",
                              hintWeight: FontWeight.bold,
                              controller: salaryMinController,
                              cursorColor: ElevateColor.black,
                              underlineColor: ElevateColor.black,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: CustomTextField(
                              hintText: "Max Salary",
                              hintWeight: FontWeight.bold,
                              controller: salaryMaxController,
                              cursorColor: ElevateColor.black,
                              underlineColor: ElevateColor.black,
                            ),
                          ),
                        ],
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
                            hintText: "Select Badge",
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
                      isPosting
                          ? const CircularProgressIndicator()
                          : TextButtonGradient(
                              text: "POST NOW",
                              height: 50,
                              textSize: 14,
                              textWeight: FontWeight.w400,
                              borderRadius: 50,
                              onTap: _postJob,
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
