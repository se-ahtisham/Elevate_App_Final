import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Message_Box/messageBox.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Database/Online_Database/admin_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminAddJobSeeker extends StatefulWidget {
  const AdminAddJobSeeker({super.key});

  @override
  State<AdminAddJobSeeker> createState() => _AdminAddJobSeekerState();
}

class _AdminAddJobSeekerState extends State<AdminAddJobSeeker> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AdminService adminService = AdminService();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> registerJobSeeker() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => Messagebox(message: "Please fill in all fields."),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await adminService.createJobSeeker(
        name: name,
        email: email,
        password: password,
      );

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });

      showDialog(
        context: context,
        builder: (_) => Messagebox(
          message: "Account created successfully.",
          onOkTap: () {
            Navigator.pop(context);
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });

      String error;
      switch (e.code) {
        case "email-already-in-use":
          error = "Email already exists.";
          break;
        case "weak-password":
          error = "Password is too weak.";
          break;
        case "invalid-email":
          error = "Invalid email address.";
          break;
        default:
          error = e.message ?? "Something went wrong.";
      }

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => Messagebox(message: error),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });

      showDialog(
        context: context,
        builder: (_) => Messagebox(message: e.toString()),
      );
    }
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

                  isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                        )
                      : TextButtonGradient(
                          text: "Register",
                          height: 60,
                          borderRadius: 50,
                          textSize: 14,
                          textWeight: FontWeight.w500,
                          onTap: registerJobSeeker,
                        ),
                  const SizedBox(height: 16),

                  TexxtButton(
                    text: "Cancel",
                    height: 60,
                    borderRadius: 38,
                    textSize: 13,
                    textWeight: FontWeight.w400,
                    textColor: ElevateColor.gray,
                    backgroundColor: const Color(0xFFF3F3F3),
                    borderColor: const Color(0xFF8B8B8B),
                    borderWidth: 1,
                    onTap: isLoading ? null : () => Navigator.maybePop(context),
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
