import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminAddJobSeekerScreen extends StatefulWidget {
  const AdminAddJobSeekerScreen({super.key});

  @override
  State<AdminAddJobSeekerScreen> createState() =>
      _AdminAddJobSeekerScreenState();
}

class _AdminAddJobSeekerScreenState extends State<AdminAddJobSeekerScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            ElevateHeader(
              title: "Add",
              subTitle: " Job Seeker",
              titleSize: 36,
              subtitleSize: 25,
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: CustomText(
                      text: "Name",
                      fontSize: 13,
                      color: const Color(0xFF777777),
                      fontWeight: FontWeight.w500,
                      lineHeight: 1.0,
                    ),
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    controller: nameController,
                    hintText: "Enter name",
                    cursorColor: ElevateColor.gray,
                    underlineColor: const Color(0xFF8B8B8B),
                    fontSize: 14,
                  ),
                  const SizedBox(height: 50),

                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: CustomText(
                      text: "Email",
                      fontSize: 13,
                      color: const Color(0xFF777777),
                      fontWeight: FontWeight.w500,
                      lineHeight: 1.0,
                    ),
                  ),
                  const SizedBox(height: 28),
                  CustomTextField(
                    controller: emailController,
                    hintText: "Enter email",
                    cursorColor: ElevateColor.gray,
                    underlineColor: const Color(0xFF8B8B8B),
                    fontSize: 14,
                  ),
                  const SizedBox(height: 50),

                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: CustomText(
                      text: "Set Password",
                      fontSize: 13,
                      color: const Color(0xFF777777),
                      fontWeight: FontWeight.w500,
                      lineHeight: 1.0,
                    ),
                  ),
                  const SizedBox(height: 28),
                  CustomTextField(
                    controller: passwordController,
                    hintText: "Enter password",
                    obscureText: true,
                    cursorColor: ElevateColor.gray,
                    underlineColor: const Color(0xFF8B8B8B),
                    fontSize: 14,
                  ),
                  const SizedBox(height: 50),

                  TextButtonGradient(
                    text: "Register",
                    height: 46,
                    borderRadius: 10,
                    textSize: 14,
                    textWeight: FontWeight.w500,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 16),

                  TexxtButton(
                    text: "Cancel",
                    height: 42,
                    borderRadius: 8,
                    textSize: 13,
                    textWeight: FontWeight.w400,
                    textColor: ElevateColor.gray,
                    backgroundColor: const Color(0xFFF3F3F3),
                    borderColor: const Color(0xFF8B8B8B),
                    borderWidth: 1,
                    onTap: () {
                      Navigator.maybePop(context);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
