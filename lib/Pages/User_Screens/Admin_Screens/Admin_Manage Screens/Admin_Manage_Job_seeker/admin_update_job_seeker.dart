import 'package:elevate_app/Custom_Widgets/Buttons/icon_text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Message_Box/messageBox.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/education_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_experience_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminUpdateJobSeeker extends StatefulWidget {
  const AdminUpdateJobSeeker({super.key});

  @override
  State<AdminUpdateJobSeeker> createState() => _AdminUpdateJobSeekerState();
}

class _AdminUpdateJobSeekerState extends State<AdminUpdateJobSeeker> {
  final FirebaseService firebaseService = FirebaseService();

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final aboutController = TextEditingController();
  final locationController = TextEditingController();
  final expLevelController = TextEditingController();
  final List<List<TextEditingController>> eduList = [];
  final List<List<TextEditingController>> expList = [];

  JobSeekerModel? foundJobSeeker; // the job seeker currently loaded
  bool isSearching = false;
  bool isUpdating = false;

  @override
  void dispose() {
    emailController.dispose();
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

  Future<void> searchJobSeeker() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const Messagebox(message: "Please enter an email."),
      );
      return;
    }

    setState(() {
      isSearching = true;
    });

    try {
      final jobSeeker = await firebaseService.getJobSeekerByEmail(email);

      if (!mounted) return;
      setState(() {
        isSearching = false;
      });

      if (jobSeeker == null) {
        showDialog(
          context: context,
          builder: (_) => const Messagebox(message: "User not found."),
        );
        return;
      }

      // Fill the form fields with this job seeker's data.
      foundJobSeeker = jobSeeker;
      nameController.text = jobSeeker.name;
      locationController.text = jobSeeker.location;
      aboutController.text = jobSeeker.about;
      expLevelController.text = jobSeeker.experienceLevel;

      eduList.clear();
      for (final edu in jobSeeker.education) {
        eduList.add([
          TextEditingController(text: edu.year),
          TextEditingController(text: edu.title),
          TextEditingController(text: edu.school),
        ]);
      }

      expList.clear();
      for (final exp in jobSeeker.jobExperience) {
        expList.add([
          TextEditingController(text: exp.jobTitle),
          TextEditingController(text: exp.company),
          TextEditingController(text: exp.from),
          TextEditingController(text: exp.to),
        ]);
      }

      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isSearching = false;
      });
      showDialog(
        context: context,
        builder: (_) => Messagebox(message: e.toString()),
      );
    }
  }

  Future<void> updateJobSeeker() async {
    if (foundJobSeeker == null) return;

    setState(() {
      isUpdating = true;
    });

    try {
      await firebaseService.updateJobSeeker(foundJobSeeker!.jobSeekerID, {
        'name': nameController.text.trim(),
        'location': locationController.text.trim(),
        'about': aboutController.text.trim(),
        'experienceLevel': expLevelController.text.trim(),
        'education': eduList
            .map(
              (e) => EducationModel(
                year: e[0].text.trim(),
                title: e[1].text.trim(),
                school: e[2].text.trim(),
              ).toMap(),
            )
            .toList(),
        'jobExperience': expList
            .map(
              (e) => JobExperienceModel(
                jobTitle: e[0].text.trim(),
                company: e[1].text.trim(),
                from: e[2].text.trim(),
                to: e[3].text.trim(),
              ).toMap(),
            )
            .toList(),
      });

      if (!mounted) return;
      setState(() {
        isUpdating = false;
      });

      showDialog(
        context: context,
        builder: (_) => Messagebox(
          message: "Job seeker updated successfully.",
          onOkTap: () => Navigator.pop(context),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isUpdating = false;
      });
      showDialog(
        context: context,
        builder: (_) => Messagebox(
          message: e.toString(),
          onOkTap: () => Navigator.pop(context),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ElevateHeader(
              title: "User Info",
              subTitle: "Let's Discover User",
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search by email
                    CustomText(
                      text: "Search by Email",
                      fontSize: 15,
                      color: const Color.fromARGB(255, 44, 44, 44),
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 75, 75, 75),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomTextField(
                          hintText: "Enter job seeker's email",
                          controller: emailController,
                          cursorColor: ElevateColor.black,
                          underlineColor: Colors.transparent,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    isSearching
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : TextButtonGradient(
                            text: "Search",
                            height: 50,
                            borderRadius: 50,
                            textSize: 14,
                            textWeight: FontWeight.w500,
                            onTap: searchJobSeeker,
                          ),
                    const SizedBox(height: 20),
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

                    // Only show the rest of the form once a user is found.
                    if (foundJobSeeker != null) ...[
                      CustomText(
                        text: "Name",
                        fontSize: 15,
                        color: const Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 75, 75, 75),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextField(
                            hintText: "Ahtisham",
                            controller: nameController,
                            cursorColor: ElevateColor.black,
                            underlineColor: Colors.transparent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      CustomText(
                        text: "About me",
                        fontSize: 15,
                        color: const Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 75, 75, 75),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextField(
                            hintText: "Hello I'm Ahtisham",
                            controller: aboutController,
                            cursorColor: ElevateColor.black,
                            underlineColor: Colors.transparent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      CustomText(
                        text: "Experience Level",
                        fontSize: 15,
                        color: const Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 75, 75, 75),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextField(
                            hintText: "1-10",
                            controller: expLevelController,
                            cursorColor: ElevateColor.black,
                            underlineColor: Colors.transparent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      CustomText(
                        text: "Location",
                        fontSize: 15,
                        color: const Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 75, 75, 75),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextField(
                            hintText: "Lahore",
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
                          ),
                          const Spacer(),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                hintText: "Year",
                                controller: eduList[i][0],
                                cursorColor: ElevateColor.black,
                                fontSize: 12,
                                underlineColor: Colors.black,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                hintText: "Degree",
                                controller: eduList[i][1],
                                cursorColor: ElevateColor.black,
                                fontSize: 12,
                                underlineColor: Colors.black,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                hintText: "School",
                                controller: eduList[i][2],
                                cursorColor: ElevateColor.black,
                                fontSize: 12,
                                underlineColor: Colors.black,
                              ),
                              const SizedBox(height: 20),
                              IconTextButtonGradient(
                                onTap: () =>
                                    setState(() => eduList.removeAt(i)),
                                text: "Delete",
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
                          ),
                          const Spacer(),
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
                              CustomTextField(
                                hintText: "Job Title",
                                controller: expList[i][0],
                                cursorColor: ElevateColor.black,
                                fontSize: 12,
                                underlineColor: Colors.black,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                hintText: "Company",
                                controller: expList[i][1],
                                cursorColor: ElevateColor.black,
                                underlineColor: Colors.black,
                                fontSize: 12,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                hintText: "From",
                                controller: expList[i][2],
                                cursorColor: ElevateColor.black,
                                fontSize: 12,
                                underlineColor: Colors.black,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                hintText: "To",
                                controller: expList[i][3],
                                cursorColor: ElevateColor.black,
                                underlineColor: Colors.black,
                                fontSize: 12,
                              ),
                              const SizedBox(height: 20),
                              IconTextButtonGradient(
                                onTap: () =>
                                    setState(() => expList.removeAt(i)),
                                text: "Delete",
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

                      isUpdating
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : TextButtonGradient(
                              text: "Update",
                              height: 50,
                              borderRadius: 50,
                              textSize: 14,
                              textWeight: FontWeight.w400,
                              onTap: updateJobSeeker,
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
                      const SizedBox(height: 30),
                    ],
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
