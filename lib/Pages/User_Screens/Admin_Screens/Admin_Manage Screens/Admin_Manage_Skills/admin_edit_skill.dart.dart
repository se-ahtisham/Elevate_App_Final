import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/edit_skill_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AdminEditSkill extends StatefulWidget {
  final String initialTitle;
  final String initialDescription;
  final void Function(String title, String description) onSubmit;

  const AdminEditSkill({
    super.key,
    this.initialTitle = "",
    this.initialDescription = "",
    required this.onSubmit,
  });

  @override
  State<AdminEditSkill> createState() => AdminEditSkillState();
}

class AdminEditSkillState extends State<AdminEditSkill> {
  late final TextEditingController titleController =
      TextEditingController(text: widget.initialTitle);
  late final TextEditingController descriptionController =
      TextEditingController(text: widget.initialDescription);

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void onUpdateSkill() {
    widget.onSubmit(titleController.text.trim(), descriptionController.text.trim());
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
              subTitle: "Badges",
              titleSize: 40,
              subtitleSize: 25,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
                child: EditSkillCard(
                  titleController: titleController,
                  descriptionController: descriptionController,
                  onUpdateTap: onUpdateSkill,
                  onCancelTap: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}