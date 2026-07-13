import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/manage_white_black_full.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/new_skill_card.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Skills/admin_edit_skill.dart.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminSkillManagement extends StatefulWidget {
  const AdminSkillManagement({super.key});

  @override
  State<AdminSkillManagement> createState() => AdminSkillManagementState();
}

class AdminSkillManagementState extends State<AdminSkillManagement> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Replace with your real data source.
  final List<String> skills = ["Java Mobile Application"];

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void onCreateNow() {
    final title = titleController.text.trim();
    if (title.isEmpty) return;

    setState(() {
      skills.add(title);
      titleController.clear();
      descriptionController.clear();
    });
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
            ElevateHeader(
              title: "Elevate",
              subTitle: "Skills",
              titleSize: 40,
              subtitleSize: 18,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NewSkillCard(
                      titleController: titleController,
                      descriptionController: descriptionController,
                      onCreateTap: onCreateNow,
                    ),
                    const SizedBox(height: 34),
                    IconText(
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
                    ),
                    const SizedBox(height: 16),
                    ...skills.map(
                      (skill) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ManageWhiteBlackFull(
                          titleText: 'Manage',
                          subtitleText: skill,
                          firstContainerWidth: 310,
                          secondContainerWidth: 140,
                          titleFontSize: 14,
                          subtitleFontSize: 26,
                          tileHeight: 100,
                          lineHeight: 1,
                          firstContainerColor: ElevateColor.white,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminEditSkill(
                                  initialTitle: skill,
                                  onSubmit: (title, description) {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          },
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
