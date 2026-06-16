import 'package:elevate_app/Custom_Widgets/Buttons/contain_icon_text_button.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/icon_text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/education_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_experience_model.dart';
import 'package:elevate_app/Database/Online_Database/Provider/auth_notifier.dart';
import 'package:elevate_app/Database/Online_Database/Provider/auth_provider.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobSeekerUpdateProfile extends ConsumerStatefulWidget {
  const JobSeekerUpdateProfile({super.key});

  @override
  ConsumerState<JobSeekerUpdateProfile> createState() => _State();
}

class _State extends ConsumerState<JobSeekerUpdateProfile> {
  bool isLoadingData = true;
  final nameController = TextEditingController();
  final aboutController = TextEditingController();
  final locationController = TextEditingController();
  final expLevelController = TextEditingController();
  final List<List<TextEditingController>> eduList = [];
  final List<List<TextEditingController>> expList = [];

  @override
  void dispose() {
    nameController.dispose();
    aboutController.dispose();
    locationController.dispose();
    expLevelController.dispose();
    for (final e in eduList) {
      for (var c in e) {
        c.dispose();
      }
    }

    for (final e in expList) {
      for (var c in e) {
        c.dispose();
      }
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    final uid = user.userID;

    final userData = await db_firebaseservice.getUser(uid);
    final js = await db_firebaseservice.getJobSeeker(uid);

    if (!mounted) return;

    // USER COLLECTION
    nameController.text = userData?.name ?? '';
    locationController.text = userData?.location ?? '';
    aboutController.text = userData?.about ?? '';

    // JOB SEEKER COLLECTION
    expLevelController.text = js?.experienceLevel ?? '';

    // CLEAR OLD DATA FIRST
    eduList.clear();
    expList.clear();

    // EDUCATION
    for (final edu in (js?.education ?? [])) {
      eduList.add([
        TextEditingController(text: edu.year),
        TextEditingController(text: edu.title),
        TextEditingController(text: edu.school),
      ]);
    }

    // EXPERIENCE
    for (final exp in (js?.jobExperience ?? [])) {
      expList.add([
        TextEditingController(text: exp.jobTitle),
        TextEditingController(text: exp.company),
        TextEditingController(text: exp.from),
        TextEditingController(text: exp.to),
      ]);
    }

    setState(() {
      isLoadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;
    if (isLoadingData) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevateHeader(
              title: "Update Profile",
              subTitle: "Make your profile stand out in the system",
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Hey there!",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 4),
                          CustomText(
                            text: nameController.text,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 4),
                          CustomText(
                            text: "Keep your profile fresh and updated",
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      CustomText(
                        text: "Name",
                        fontSize: 15,
                        color: const Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 350,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: const Color.fromARGB(255, 75, 75, 75),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextField(
                            hintText: "Ahtisham",
                            hintWeight: FontWeight.w400,
                            controller: nameController,
                            cursorColor: ElevateColor.black,
                            underlineColor: Colors.transparent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // About
                      CustomText(
                        text: "About me",
                        fontSize: 15,
                        color: const Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 350,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: const Color.fromARGB(255, 75, 75, 75),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextField(
                            hintText: "Hello! I am flutter developer!",
                            hintWeight: FontWeight.w400,
                            controller: aboutController,
                            cursorColor: ElevateColor.black,
                            underlineColor: Colors.transparent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Experience Level
                      CustomText(
                        text: "Experience Level",
                        fontSize: 15,
                        color: const Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 350,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: const Color.fromARGB(255, 75, 75, 75),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextField(
                            hintText: "3-5 Years",
                            hintWeight: FontWeight.w400,
                            controller: expLevelController,
                            cursorColor: ElevateColor.black,
                            underlineColor: Colors.transparent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Location
                      CustomText(
                        text: "Location",
                        fontSize: 15,
                        color: const Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 350,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: const Color.fromARGB(255, 75, 75, 75),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextField(
                            hintText: "Lahore",
                            hintWeight: FontWeight.w400,
                            controller: locationController,
                            cursorColor: ElevateColor.black,
                            underlineColor: Colors.transparent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Education
                      Row(
                        children: [
                          CustomText(
                            text: "Education",
                            fontSize: 15,
                            color: const Color.fromARGB(255, 44, 44, 44),
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(width: 240),
                          GestureDetector(
                            onTap: () => setState(
                              () => eduList.add([
                                TextEditingController(), // Year
                                TextEditingController(), // Degree
                                TextEditingController(), // School
                              ]),
                            ),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 59, 59, 59),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (int i = 0; i < eduList.length; i++)
                        Container(
                          width: 350,
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 75, 75, 75),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              CustomTextField(
                                hintText: "Year (e.g. 2021)",
                                hintWeight: FontWeight.w400,
                                controller: eduList[i][0],
                                cursorColor: ElevateColor.black,
                                contentPadding: EdgeInsets.only(bottom: 15),
                                underlineColor: const Color.fromARGB(
                                  131,
                                  128,
                                  128,
                                  128,
                                ),
                                fontSize: 12,
                              ),
                              const SizedBox(height: 25),
                              CustomTextField(
                                hintText: "Degree (e.g. BSc CS)",
                                hintWeight: FontWeight.w400,
                                controller: eduList[i][1],
                                cursorColor: ElevateColor.black,
                                fontSize: 12,
                                contentPadding: EdgeInsets.only(bottom: 15),
                                underlineColor: const Color.fromARGB(
                                  131,
                                  128,
                                  128,
                                  128,
                                ),
                              ),
                              const SizedBox(height: 25),
                              CustomTextField(
                                hintText: "School (e.g. FAST)",
                                hintWeight: FontWeight.w400,
                                controller: eduList[i][2],
                                cursorColor: ElevateColor.black,
                                contentPadding: EdgeInsets.only(bottom: 15),
                                underlineColor: const Color.fromARGB(
                                  131,
                                  128,
                                  128,
                                  128,
                                ),
                                fontSize: 12,
                              ),
                              const SizedBox(height: 25),
                              IconTextButtonGradient(
                                onTap: () =>
                                    setState(() => eduList.removeAt(i)),
                                text: "Delete",
                                width: 350,
                                textColor: Colors.white,
                                iconColor: Colors.white,
                                iconData: Icons.delete,
                                iconSize: 13,
                                textSize: 10,
                                height: 40,
                                startColor: const Color.fromARGB(
                                  255,
                                  136,
                                  136,
                                  136,
                                ),
                                endColor: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 30),

                      // Work Experience
                      Row(
                        children: [
                          CustomText(
                            text: "Work Experience",
                            fontSize: 15,
                            color: const Color.fromARGB(255, 44, 44, 44),
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(width: 185),
                          GestureDetector(
                            onTap: () => setState(
                              () => expList.add([
                                TextEditingController(), // Job Title
                                TextEditingController(), // Company
                                TextEditingController(), // From
                                TextEditingController(), // To
                              ]),
                            ),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 59, 59, 59),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      for (int i = 0; i < expList.length; i++)
                        Container(
                          width: 350,
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 75, 75, 75),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),

                              CustomTextField(
                                hintText: "Job Title",
                                hintWeight: FontWeight.w400,
                                controller: expList[i][0],
                                cursorColor: ElevateColor.black,
                                contentPadding: const EdgeInsets.only(
                                  bottom: 15,
                                ),
                                underlineColor: const Color.fromARGB(
                                  131,
                                  128,
                                  128,
                                  128,
                                ),
                                fontSize: 12,
                              ),

                              const SizedBox(height: 25),

                              CustomTextField(
                                hintText: "Company",
                                hintWeight: FontWeight.w400,
                                controller: expList[i][1],
                                cursorColor: ElevateColor.black,
                                contentPadding: const EdgeInsets.only(
                                  bottom: 15,
                                ),
                                underlineColor: const Color.fromARGB(
                                  131,
                                  128,
                                  128,
                                  128,
                                ),
                                fontSize: 12,
                              ),

                              const SizedBox(height: 25),

                              CustomTextField(
                                hintText: "From (e.g. Jan 2022)",
                                hintWeight: FontWeight.w400,
                                controller: expList[i][2],
                                cursorColor: ElevateColor.black,
                                contentPadding: const EdgeInsets.only(
                                  bottom: 15,
                                ),
                                underlineColor: const Color.fromARGB(
                                  131,
                                  128,
                                  128,
                                  128,
                                ),
                                fontSize: 12,
                              ),

                              const SizedBox(height: 25),

                              CustomTextField(
                                hintText: "To (e.g. Present)",
                                hintWeight: FontWeight.w400,
                                controller: expList[i][3],
                                cursorColor: ElevateColor.black,
                                contentPadding: const EdgeInsets.only(
                                  bottom: 15,
                                ),
                                underlineColor: const Color.fromARGB(
                                  131,
                                  128,
                                  128,
                                  128,
                                ),
                                fontSize: 12,
                              ),

                              const SizedBox(height: 25),

                              IconTextButtonGradient(
                                onTap: () =>
                                    setState(() => expList.removeAt(i)),
                                text: "Delete",
                                width: 350,
                                textColor: Colors.white,
                                iconColor: Colors.white,
                                iconData: Icons.delete,
                                iconSize: 13,
                                textSize: 10,
                                height: 40,
                                startColor: const Color.fromARGB(
                                  255,
                                  136,
                                  136,
                                  136,
                                ),
                                endColor: Colors.black,
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 50),

                      // Buttons
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : TextButtonGradient(
                              text: "Update",
                              height: 50,
                              textSize: 14,
                              borderRadius: 50,
                              width: 350,
                              textWeight: FontWeight.w400,
                              onTap: () async {
                                final notifier = ref.read(
                                  authProvider.notifier,
                                );

                                final success = await notifier
                                    .updateFullProfile(
                                      name: nameController.text.trim(),
                                      location: locationController.text.trim(),
                                      about: aboutController.text.trim(),
                                      experienceLevel: expLevelController.text
                                          .trim(),
                                      educations: eduList
                                          .map(
                                            (e) => EducationModel(
                                              year: e[0].text.trim(),
                                              title: e[1].text.trim(),
                                              school: e[2].text.trim(),
                                            ),
                                          )
                                          .toList(),
                                      experiences: expList
                                          .map(
                                            (e) => JobExperienceModel(
                                              jobTitle: e[0].text.trim(),
                                              company: e[1].text.trim(),
                                              from: e[2].text.trim(),
                                              to: e[3].text.trim(),
                                            ),
                                          )
                                          .toList(),
                                    );

                                if (success && mounted) Navigator.pop(context);
                              },
                            ),
                      const SizedBox(height: 30),
                      TexxtButton(
                        text: "Cancel",
                        width: 350,
                        height: 50,
                        textSize: 14,
                        textWeight: FontWeight.w400,
                        textColor: Colors.black,
                        backgroundColor: Colors.transparent,
                        borderRadius: 50,
                        borderColor: Colors.black,
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 30),
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
