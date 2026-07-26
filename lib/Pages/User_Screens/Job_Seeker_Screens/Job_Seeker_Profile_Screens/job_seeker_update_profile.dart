import 'dart:io';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/education_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_experience_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_storage_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class JobSeekerUpdateProfile extends ConsumerStatefulWidget {
  const JobSeekerUpdateProfile({super.key});

  @override
  ConsumerState<JobSeekerUpdateProfile> createState() =>
      JobSeekerUpdateProfileState();
}

class JobSeekerUpdateProfileState
    extends ConsumerState<JobSeekerUpdateProfile> {
  final storageService = FirebaseStorageService();

  bool isLoadingData = true;
  final nameController = TextEditingController();
  final aboutController = TextEditingController();
  final locationController = TextEditingController();
  final expLevelController = TextEditingController();
  final List<List<TextEditingController>> eduList = [];
  final List<List<TextEditingController>> expList = [];

  File? selectedProfileImage;
  final picker = ImagePicker();

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
    final notifier = ref.read(authProvider.notifier);
    await notifier.loadCurrentUser();

    final jobSeeker = ref.read(authProvider).jobSeeker;
    if (jobSeeker == null || !mounted) return;

    nameController.text = jobSeeker.name;
    locationController.text = jobSeeker.location;
    aboutController.text = jobSeeker.about;
    expLevelController.text = jobSeeker.experienceLevel;

    eduList.clear();
    expList.clear();

    for (final edu in jobSeeker.education) {
      eduList.add([
        TextEditingController(text: edu.year),
        TextEditingController(text: edu.title),
        TextEditingController(text: edu.school),
      ]);
    }

    for (final exp in jobSeeker.jobExperience) {
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

  Future<void> pickProfileImage() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null && mounted) {
      final file = File(picked.path);

      // Validate file size < 100 KB
      if (!storageService.validateFileSize(file, context)) {
        return;
      }

      setState(() {
        selectedProfileImage = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;
    final user = ref.watch(authProvider).jobSeeker;

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
            const ElevateHeader(
              title: "Update Profile",
              subTitle: "Make your profile stand out in the system",
              showBackButton: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: pickProfileImage,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.grey.shade200,
                                  backgroundImage: selectedProfileImage != null
                                      ? FileImage(selectedProfileImage!)
                                      : (user?.profilePic.isNotEmpty == true
                                                ? NetworkImage(user!.profilePic)
                                                : null)
                                            as ImageProvider?,
                                  child:
                                      selectedProfileImage == null &&
                                          (user?.profilePic.isEmpty ?? true)
                                      ? Text(
                                          user?.name.isNotEmpty == true
                                              ? user!.name[0].toUpperCase()
                                              : "?",
                                          style: const TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CustomText(
                                  text: "Hey there!",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 2),
                                CustomText(
                                  text: nameController.text,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 2),
                                const CustomText(
                                  text: "Tap photo to change (< 1MB)",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Name
                      const CustomText(
                        text: "Name",
                        fontSize: 15,
                        color: Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
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
                      const SizedBox(height: 25),

                      // Location
                      const CustomText(
                        text: "Location",
                        fontSize: 15,
                        color: Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
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
                            hintText: "New York, USA",
                            hintWeight: FontWeight.w400,
                            controller: locationController,
                            cursorColor: ElevateColor.black,
                            underlineColor: Colors.transparent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // About
                      const CustomText(
                        text: "About me",
                        fontSize: 15,
                        color: Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 120,
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
                      const SizedBox(height: 25),

                      // Experience Level
                      const CustomText(
                        text: "Experience Level",
                        fontSize: 15,
                        color: Color.fromARGB(255, 44, 44, 44),
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
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

                      // Update & Cancel Buttons
                      isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : TextButtonGradient(
                              text: "Update Profile",
                              height: 50,
                              textSize: 14,
                              borderRadius: 50,
                              width: double.infinity,
                              textWeight: FontWeight.w500,
                              onTap: () async {
                                final navigator = Navigator.of(context);
                                final notifier = ref.read(
                                  authProvider.notifier,
                                );
                                final myID = user?.jobSeekerID;

                                String? uploadedPhotoUrl;
                                if (selectedProfileImage != null &&
                                    myID != null) {
                                  uploadedPhotoUrl = await storageService
                                      .uploadProfileImage(
                                        userId: myID,
                                        file: selectedProfileImage!,
                                        context: context,
                                      );
                                }

                                final success = await notifier
                                    .updateFullProfile(
                                      name: nameController.text.trim(),
                                      location: locationController.text.trim(),
                                      about: aboutController.text.trim(),
                                      experienceLevel: expLevelController.text
                                          .trim(),
                                      profilePic: uploadedPhotoUrl,
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

                                if (success) navigator.pop();
                              },
                            ),
                      const SizedBox(height: 15),
                      TexxtButton(
                        text: "Cancel",
                        width: double.infinity,
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
