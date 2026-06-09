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
    for (final e in eduList) for (var c in e) c.dispose();
    for (final e in expList) for (var c in e) c.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Basic fields come from UserModel
      final user = ref.read(authProvider).user;
      if (user != null) {
        nameController.text = user.name;
        locationController.text = user.location;
        aboutController.text = user.about;
      }

      // Education & Experience come from JobSeekerModel (separate Firestore collection)
      final uid = user?.userID;
      if (uid == null) return;

      final js = await db_firebaseservice.getJobSeeker(uid);
      if (js == null || !mounted) return;

      setState(() {
        expLevelController.text = js.experienceLevel ?? '';

        for (final edu in js.education) {
          eduList.add([
            TextEditingController(text: edu.year),
            TextEditingController(text: edu.title),
            TextEditingController(text: edu.school),
          ]);
        }

        for (final exp in js.jobExperience) {
          expList.add([
            TextEditingController(text: exp.jobTitle),
            TextEditingController(text: exp.company),
            TextEditingController(text: exp.from),
            TextEditingController(text: exp.to),
          ]);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevateHeader(title: "My Info", subTitle: "Let's Discover My Self"),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      UserDescription(
                        imageURL:
                            'https://avatars.githubusercontent.com/u/159082885?v=4',
                        name: "Muhammad Ahtisham",
                        shortDescription: "Backend Developer",
                        skills: 10,
                        followers: 238,
                        followings: 101,
                      ),
                      SizedBox(height: 30),
                      CustomText(
                        text: "Name",
                        fontSize: 13,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
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
                      const SizedBox(height: 20),

                      // About
                      CustomText(
                        text: "About me",
                        fontSize: 13,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
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
                      const SizedBox(height: 20),

                      // Experience Level
                      CustomText(
                        text: "Experience Level",
                        fontSize: 13,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
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
                      const SizedBox(height: 20),

                      // Location
                      CustomText(
                        text: "Location",
                        fontSize: 13,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
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
                      const SizedBox(height: 25),

                      // Education
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "Education",
                            fontSize: 13,
                            color: ElevateColor.whitegray,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.left,
                          ),
                          GestureDetector(
                            onTap: () => setState(
                              () => eduList.add([
                                TextEditingController(),
                                TextEditingController(),
                                TextEditingController(),
                              ]),
                            ),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (int i = 0; i < eduList.length; i++)
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 75, 75, 75),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              CustomTextField(
                                hintText: "Year (e.g. 2021)",
                                hintWeight: FontWeight.w400,
                                controller: eduList[i][0],
                                cursorColor: ElevateColor.black,
                                underlineColor: Colors.transparent,
                                fontSize: 12,
                              ),
                              CustomTextField(
                                hintText: "Degree (e.g. BSc CS)",
                                hintWeight: FontWeight.w400,
                                controller: eduList[i][1],
                                cursorColor: ElevateColor.black,
                                underlineColor: Colors.transparent,
                                fontSize: 12,
                              ),
                              CustomTextField(
                                hintText: "School (e.g. FAST)",
                                hintWeight: FontWeight.w400,
                                controller: eduList[i][2],
                                cursorColor: ElevateColor.black,
                                underlineColor: Colors.transparent,
                                fontSize: 12,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => eduList.removeAt(i)),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 25),

                      // Work Experience
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "Work Experience",
                            fontSize: 13,
                            color: ElevateColor.whitegray,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.left,
                          ),
                          GestureDetector(
                            onTap: () => setState(
                              () => expList.add([
                                TextEditingController(),
                                TextEditingController(),
                                TextEditingController(),
                                TextEditingController(),
                              ]),
                            ),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (int i = 0; i < expList.length; i++)
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 75, 75, 75),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              CustomTextField(
                                hintText: "Job Title",
                                hintWeight: FontWeight.w400,
                                controller: expList[i][0],
                                cursorColor: ElevateColor.black,
                                underlineColor: Colors.transparent,
                                fontSize: 12,
                              ),
                              CustomTextField(
                                hintText: "Company",
                                hintWeight: FontWeight.w400,
                                controller: expList[i][1],
                                cursorColor: ElevateColor.black,
                                underlineColor: Colors.transparent,
                                fontSize: 12,
                              ),
                              CustomTextField(
                                hintText: "From (e.g. Jan 2022)",
                                hintWeight: FontWeight.w400,
                                controller: expList[i][2],
                                cursorColor: ElevateColor.black,
                                underlineColor: Colors.transparent,
                                fontSize: 12,
                              ),
                              CustomTextField(
                                hintText: "To (e.g. Present)",
                                hintWeight: FontWeight.w400,
                                controller: expList[i][3],
                                cursorColor: ElevateColor.black,
                                underlineColor: Colors.transparent,
                                fontSize: 12,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => expList.removeAt(i)),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 30),

                      // Buttons
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : TextButtonGradient(
                              text: "Update",
                              height: 50,
                              textSize: 14,
                              textWeight: FontWeight.w400,
                              borderRadius: 50,
                              onTap: () async {
                                final success = await ref
                                    .read(authProvider.notifier)
                                    .updateProfile(
                                      name: nameController.text,
                                      shortDescription: aboutController.text,
                                      experienceLevel: expLevelController.text,
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
                      const SizedBox(height: 20),
                      TexxtButton(
                        text: "Cancel",
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
