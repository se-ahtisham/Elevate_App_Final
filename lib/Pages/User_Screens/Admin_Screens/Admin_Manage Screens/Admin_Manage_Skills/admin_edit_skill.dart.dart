import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  late final TextEditingController titleController = TextEditingController(
    text: widget.initialTitle,
  );
  late final TextEditingController descriptionController =
      TextEditingController(text: widget.initialDescription);

  late String? skillImagePath = widget.initialImage.isEmpty
      ? null
      : widget.initialImage;

  bool isUpdating = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickSkillImage() async {
    final images = ["sharp.png", "java.png", "python.png"];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: images.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (_, index) {
              return GestureDetector(
                onTap: () {
                  setState(() => skillImagePath = images[index]);
                  Navigator.pop(context);
                },
                child: Image.asset(
                  "lib/Resources/Images/Skills/${images[index]}",
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> onUpdateSkill() async {
    setState(() => isUpdating = true);
    try {
      await Future.sync(
        () => widget.onSubmit(
          titleController.text.trim(),
          descriptionController.text.trim(),
          skillImagePath ?? '',
        ),
      );
    } finally {
      if (mounted) setState(() => isUpdating = false);
    }
  }

  // Same label + bordered-container + CustomTextField pattern as your
  // LoginScreen (Email/Password fields).
  Widget _labeledField({
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

                    // The single image placeholder for this screen.
                    Center(
                      child: GestureDetector(
                        onTap: pickSkillImage,
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Color.fromARGB(255, 199, 199, 199),

                          backgroundImage:
                              skillImagePath != null &&
                                  skillImagePath!.isNotEmpty
                              ? AssetImage(
                                      "lib/Resources/Images/Skills/$skillImagePath",
                                    )
                                    as ImageProvider
                              : null,
                          child:
                              skillImagePath == null || skillImagePath!.isEmpty
                              ? const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 30,
                                )
                              : null,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    _labeledField(
                      label: "Skill Name",
                      controller: titleController,
                    ),

                    const SizedBox(height: 30),

                    _labeledField(
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
