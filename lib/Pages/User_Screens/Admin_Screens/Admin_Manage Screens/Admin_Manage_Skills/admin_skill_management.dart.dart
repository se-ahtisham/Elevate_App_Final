import 'dart:io';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/manage_white_black_full.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/newsSkill_card.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/skill_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Database/Online_Database/firebase_storage_service.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Skills/admin_edit_skill.dart.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AdminSkillManagement extends StatefulWidget {
  const AdminSkillManagement({super.key});

  @override
  State<AdminSkillManagement> createState() => AdminSkillManagementState();
}

class AdminSkillManagementState extends State<AdminSkillManagement> {
  final FirebaseService firebaseService = FirebaseService();
  final FirebaseStorageService storageService = FirebaseStorageService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  List<SkillModel> allSkills = [];
  List<SkillModel> visibleSkills = [];

  String? newSkillImageUrl;
  bool isLoading = true;
  bool isUploadingImage = false;
  bool isCreating = false;

  @override
  void initState() {
    super.initState();
    loadAllSkills();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadAllSkills() async {
    setState(() => isLoading = true);
    allSkills = await firebaseService.listAllSkills();
    setState(() {
      visibleSkills = allSkills;
      isLoading = false;
    });
  }

  void onSearchChanged(String query) {
    query = query.toLowerCase();
    setState(() {
      visibleSkills = allSkills
          .where((skill) => skill.skillName.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> pickNewSkillImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    if (!mounted) return;

    setState(() => isUploadingImage = true);
    try {
      final tempId = firebaseService.db.collection('skills').doc().id;
      final url = await storageService.uploadSkillImage(
        skillId: tempId,
        file: File(picked.path),
        context: context,
      );
      if (url != null && mounted) {
        setState(() => newSkillImageUrl = url);
      }
    } finally {
      if (mounted) setState(() => isUploadingImage = false);
    }
  }

  Future<void> onCreateNow() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a skill name.")),
      );
      return;
    }

    setState(() => isCreating = true);
    final skill = SkillModel(
      skillID: firebaseService.db.collection('skills').doc().id,
      skillName: title,
      skillDescription: description,
      skillImage: newSkillImageUrl ?? '',
    );

    try {
      await firebaseService.createNewSkill(skill);
      titleController.clear();
      descriptionController.clear();
      setState(() => newSkillImageUrl = null);
      await loadAllSkills();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to create skill: $e")));
      }
    } finally {
      if (mounted) setState(() => isCreating = false);
    }
  }

  void openEditScreen(SkillModel skill) async {
    final wasUpdated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminEditSkill(
          skillID: skill.skillID,
          initialTitle: skill.skillName,
          initialDescription: skill.skillDescription,
          initialImage: skill.skillImage,
          onSubmit: (title, description, image) async {
            await firebaseService.updateSkill(skill.skillID, {
              'skillName': title,
              'skillDescription': description,
              'skillImage': image,
            });
            if (context.mounted) Navigator.pop(context, true);
          },
        ),
      ),
    );

    if (wasUpdated == true) {
      loadAllSkills();
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
          children: [
            Stack(
              children: [
                const ElevateHeader(
                  title: "Elevate",
                  subTitle: "Skills",
                  titleSize: 40,
                  subtitleSize: 18,
                ),
                Positioned(
                  top: 170,
                  right: 120,
                  child: TexxtButton(
                    text: "Back",
                    width: 120,
                    height: 50,
                    textSize: 12,
                    textWeight: FontWeight.w500,
                    textColor: const Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: const Color.fromARGB(224, 114, 114, 114),
                    borderColor: const Color(0xFF8B8B8B),
                    borderRadius: 80,
                    borderWidth: 1,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NewSkillCard(
                      imagePath: newSkillImageUrl,
                      onPickImage: isUploadingImage ? null : pickNewSkillImage,
                      titleController: titleController,
                      descriptionController: descriptionController,
                      onCreateTap: isCreating ? null : onCreateNow,
                    ),
                    const SizedBox(height: 34),
                    const IconText(
                      text: "Explore Skill",
                      iconData: Icons.people_alt_outlined,
                      textSize: 20,
                      textWeight: FontWeight.bold,
                      iconSize: 25,
                      iconTextSpacing: 10,
                    ),
                    const SizedBox(height: 30),
                    CustomSearchBar(
                      hintText: "Java Development",
                      backgroundColor: ElevateColor.white,
                      width: double.infinity,
                      height: 60,
                      textSize: 15,
                      iconSize: 30,
                      controller: searchController,
                      onChanged: onSearchChanged,
                    ),
                    const SizedBox(height: 16),
                    if (isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                      )
                    else if (visibleSkills.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            "No skills found.",
                            style: TextStyle(
                              fontSize: 15,
                              color: ElevateColor.gray,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    else
                      ...visibleSkills.map(
                        (skill) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ManageWhiteBlackFull(
                            titleText: 'Manage',
                            subtitleText: skill.skillName,
                            firstContainerWidth: 310,
                            secondContainerWidth: 140,
                            titleFontSize: 14,
                            subtitleFontSize: 26,
                            tileHeight: 100,
                            lineHeight: 1,
                            firstContainerColor: ElevateColor.white,
                            onTap: () => openEditScreen(skill),
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
