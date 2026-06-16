import 'package:elevate_app/Custom_Widgets/Buttons/contain_icon_text_button.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class NewPortfolioScreen extends StatefulWidget {
  const NewPortfolioScreen({super.key});

  @override
  State<NewPortfolioScreen> createState() => _NewPortfolioScreenState();
}

class _NewPortfolioScreenState extends State<NewPortfolioScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          ElevateHeader(
            title: "Portfolio Project",
            subTitle: "Add new project",
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    const CustomText(
                      text: "UPLOAD IMAGES",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ElevateColor.lightgray,
                    ),

                    const SizedBox(height: 16),

                    Container(
                      height: 120,
                      width: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAEAEA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 30),

                    CustomTextField(
                      controller: titleController,
                      hintText: "Title",
                      cursorColor: Colors.black,
                      underlineColor: Colors.grey,
                    ),

                    const SizedBox(height: 40),

                    CustomTextField(
                      controller: descriptionController,
                      hintText: "Description",
                      cursorColor: Colors.black,
                      underlineColor: Colors.grey,
                    ),

                    const SizedBox(height: 25),

                    const CustomText(
                      text: "Files",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ElevateColor.lightgray,
                    ),

                    const SizedBox(height: 12),

                    ContainIconTextButton(text: "Add Files", onTap: () {}),

                    const SizedBox(height: 40),

                    TextButtonGradient(
                      text: "ADD PROJECT",
                      height: 50,
                      textSize: 14,
                      textColor: ElevateColor.white,
                      textWeight: FontWeight.w400,
                      borderRadius: 50,
                      borderColor: ElevateColor.gray,
                      borderWidth: 1,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),

                    const SizedBox(height: 35),

                    TexxtButton(
                      text: "Back",
                      height: 50,
                      textSize: 14,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      borderColor: Colors.black,
                      borderWidth: 1,
                      textWeight: FontWeight.w400,
                      borderRadius: 50,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
