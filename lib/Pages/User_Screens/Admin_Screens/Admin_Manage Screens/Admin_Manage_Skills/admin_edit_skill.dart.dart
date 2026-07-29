import 'dart:io';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Database/Online_Database/firebase_storage_service.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Custom_Widgets/Message_Box/delete_box.dart';
import 'package:elevate_app/Custom_Widgets/Message_Box/messageBox.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AdminEditSkill extends StatefulWidget {
  final String skillID;
  final String initialTitle;
  final String initialDescription;
  final String initialImage;
  final void Function(String title, String description, String image) onSubmit;

  const AdminEditSkill({
    super.key,
    required this.skillID,
    this.initialTitle = "",
    this.initialDescription = "",
    this.initialImage = "",
    required this.onSubmit,
  });

  @override
  State<AdminEditSkill> createState() => AdminEditSkillState();
}

class AdminEditSkillState extends State<AdminEditSkill> {
  final FirebaseStorageService storageService = FirebaseStorageService();
  final firebaseService = FirebaseService();

  late final TextEditingController titleController = TextEditingController(
    text: widget.initialTitle,
  );
  late final TextEditingController descriptionController =
      TextEditingController(text: widget.initialDescription);

  late String skillImageUrl = widget.initialImage;

  bool isUpdating = false;
  bool isUploadingImage = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickSkillImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    if (!mounted) return;

    final file = File(picked.path);
    if (!storageService.validateFileSize(file, context)) {
      return;
    }

    setState(() => isUploadingImage = true);
    try {
      final url = await storageService.uploadSkillImage(
        skillId: widget.skillID,
        file: file,
        context: context,
      );
      if (url != null && mounted) {
        setState(() => skillImageUrl = url);
      }
    } finally {
      if (mounted) setState(() => isUploadingImage = false);
    }
  }

  Future<void> onUpdateSkill() async {
    setState(() => isUpdating = true);
    try {
      await Future.sync(
        () => widget.onSubmit(
          titleController.text.trim(),
          descriptionController.text.trim(),
          skillImageUrl,
        ),
      );
    } finally {
      if (mounted) setState(() => isUpdating = false);
    }
  }

  Widget labeledField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: CustomTextField(
              hintText: label,
              controller: controller,
              cursorColor: ElevateColor.black,
              underlineColor: Colors.transparent,
              obscureText: obscureText,
            ),
          ),
        ),
      ],
    );
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
            const ElevateHeader(
              title: "Elevate",
              subTitle: "Skills",
              titleSize: 40,
              subtitleSize: 25,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: isUploadingImage ? null : pickSkillImage,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundColor: const Color.fromARGB(
                                255,
                                199,
                                199,
                                199,
                              ),
                              backgroundImage: skillImageUrl.isNotEmpty
                                  ? NetworkImage(skillImageUrl)
                                  : const NetworkImage('https://ui-avatars.com/api/?name=Skill&background=E0E0E0&color=757575&size=128&bold=true') as ImageProvider,
                              child: skillImageUrl.isEmpty
                                  ? const Icon(
                                      Icons.add,
                                      color: Colors.black,
                                      size: 30,
                                    )
                                  : null,
                            ),
                            if (isUploadingImage)
                              const CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    labeledField(
                      label: "Skill Name",
                      controller: titleController,
                    ),
                    const SizedBox(height: 30),
                    labeledField(
                      label: "Description",
                      controller: descriptionController,
                    ),
                    const SizedBox(height: 30),
                    TextButtonGradient(
                      text: isUpdating ? "Updating..." : "Update Skill",
                      height: 50,
                      textSize: 16,
                      textWeight: FontWeight.w500,
                      borderRadius: 30,
                      onTap: isUpdating ? null : onUpdateSkill,
                    ),
                    const SizedBox(height: 15),
                    TexxtButton(
                      text: "Cancel",
                      textSize: 13,
                      textColor: Colors.black,
                      textWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                      backgroundColor: Colors.white,
                      borderColor: Colors.black,
                      borderRadius: 30,
                      borderWidth: 1,
                      height: 50,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 15),
                    TexxtButton(
                      text: "Delete Skill",
                      textSize: 13,
                      textColor: Colors.red,
                      textWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                      backgroundColor: Colors.white,
                      borderColor: Colors.red,
                      borderRadius: 30,
                      borderWidth: 1,
                      height: 50,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Deletebox(
                            name: titleController.text,
                            onDelete: () async {
                              try {
                                await firebaseService.deleteSkill(widget.skillID);
                                if (!context.mounted) return;
                                showDialog(
                                  context: context,
                                  builder: (_) => Messagebox(
                                    message: "Skill deleted successfully.",
                                    onOkTap: () {
                                      Navigator.pop(context); // Close dialog
                                      Navigator.pop(context, true); // Pop edit screen
                                    },
                                  ),
                                );
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Failed to delete skill.")),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
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
