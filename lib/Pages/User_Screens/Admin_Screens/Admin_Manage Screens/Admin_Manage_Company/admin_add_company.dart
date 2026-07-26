import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Message_Box/messageBox.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Database/Online_Database/admin_service.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Company/admin_manage_company.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminAddCompany extends StatefulWidget {
  const AdminAddCompany({super.key});

  @override
  State<AdminAddCompany> createState() => _AdminAddCompanyState();
}

class _AdminAddCompanyState extends State<AdminAddCompany> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AdminService adminService = AdminService();
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> registerCompany() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const Messagebox(message: "Please fill in all fields."),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await adminService.createCompany(
        companyName: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;
      setState(() => isLoading = false);

      showDialog(
        context: context,
        builder: (_) => Messagebox(
          message: "Company account created successfully.",
          onOkTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AdminManageCompany()),
            );
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      showDialog(
        context: context,
        builder: (_) => Messagebox(
          message: switch (e.code) {
            "email-already-in-use" => "Email already exists.",
            "weak-password" => "Password is too weak.",
            "invalid-email" => "Invalid email.",
            _ => e.message ?? "Something went wrong.",
          },
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      showDialog(
        context: context,
        builder: (_) => Messagebox(message: e.toString()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ElevateHeader(
            title: "Add Opportunity",
            subTitle: "Creator",
            titleSize: 30,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Company Name",
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: CustomTextField(
                        hintText: "Enter company name",
                        controller: nameController,
                        cursorColor: ElevateColor.black,
                        underlineColor: Colors.transparent,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  CustomText(
                    text: "Email",
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: CustomTextField(
                        hintText: "Enter email",
                        controller: emailController,
                        cursorColor: ElevateColor.black,
                        underlineColor: Colors.transparent,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  CustomText(
                    text: "Password",
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: CustomTextField(
                        hintText: "Enter password",
                        controller: passwordController,
                        cursorColor: ElevateColor.black,
                        underlineColor: Colors.transparent,
                        obscureText: true,
                      ),
                    ),
                  ),

                  SizedBox(height: 35),

                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        )
                      : TextButtonGradient(
                          text: "Register",
                          height: 50,
                          textSize: 16,
                          textWeight: FontWeight.w500,
                          borderRadius: 30,
                          onTap: registerCompany,
                        ),

                  SizedBox(height: 15),

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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
