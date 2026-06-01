import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Drop_Down_Menu/custom_drop_down.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Company/admin_manage_company.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/admin_manage.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminAddCompanyScreen extends StatefulWidget {
  const AdminAddCompanyScreen({super.key});

  @override
  State<AdminAddCompanyScreen> createState() => _AdminAddCompanyScreenState();
}

class _AdminAddCompanyScreenState extends State<AdminAddCompanyScreen> {
  final TextEditingController nameController =
      TextEditingController(text: "ahtisham");
  final TextEditingController emailController =
      TextEditingController(text: "ahtisham@gmail.com");
  final TextEditingController passwordController =
      TextEditingController(text: "................");
  final TextEditingController answerController =
      TextEditingController(text: "Coding");

  String? selectedQuestion = "What's your hobby?";
  String? selectedRole = "Company";

  final List<String> questions = const [
    "What's your hobby?",
    "What's your school name?",
    "What's your birth date?",
  ];

  final List<String> roles = const ["Company", "Job Seeker"];

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    answerController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF8B8B8B), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: ElevateColor.lightgray, width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFEFEFEF),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            const Flexible(
              flex: 2,
              child: ElevateHeader(
                title: "Add",
                subTitle: "Company",
                titleSize: 35,
                subtitleSize: 25,
              ),
            ),
            Flexible(
              flex: 3,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel(text: "Name"),
                    TextField(
                      controller: nameController,
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                      decoration: _fieldDecoration(),
                    ),
                     const SizedBox(height: 28),
                    const _FieldLabel(text: "Email"),
                    TextField(
                      controller: emailController,
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                      decoration: _fieldDecoration(),
                    ),
                    const SizedBox(height: 28),
                    const _FieldLabel(text: "Set Password"),
                    TextField(
                      controller: passwordController,
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                      decoration: _fieldDecoration(),
                    ),
                     const SizedBox(height: 28),
                    const _FieldLabel(text: "Security Question"),
                    SizedBox(
                      height: 34,
                      child: CustomDropDown(
                        hintText: "What's your hobby?",
                        items: questions,
                        value: selectedQuestion,
                        onChanged: (value) {
                          setState(() {
                            selectedQuestion = value;
                          });
                        },
                        borderRadius: 10,
                        borderColor: const Color(0xFF8B8B8B),
                        borderWidth: 1,
                        hintTextSize: 10,
                        textSize: 10,
                        hintTextColor: const Color(0xFF8A8A8A),
                        textColor: ElevateColor.gray,
                        backgroundColor: ElevateColor.white,
                        textWeight: FontWeight.w400,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const _FieldLabel(text: "Answer"),
                    TextField(
                      controller: answerController,
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                      decoration: _fieldDecoration(),
                    ),
                    const SizedBox(height: 28),
                    const _FieldLabel(text: "Join as"),
                    SizedBox(
                      height: 34,
                      child: CustomDropDown(
                        hintText: "Company",
                        items: roles,
                        value: selectedRole,
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                          });
                        },
                        borderRadius: 10,
                        borderColor: const Color(0xFF8B8B8B),
                        borderWidth: 1,
                        hintTextSize: 10,
                        textSize: 10,
                        hintTextColor: const Color(0xFF8A8A8A),
                        textColor: ElevateColor.gray,
                        backgroundColor: ElevateColor.white,
                        textWeight: FontWeight.w400,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                     const SizedBox(height: 28),
                    TextButtonGradient(
                      text: "Register",
                      height: 42,
                      borderRadius: 10,
                      textSize: 12,
                      textWeight: FontWeight.w500,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminManageCompany(),
                          ),
                        );
                      },
                    ),
                     const SizedBox(height: 28),
                    TexxtButton(
                      text: "Cancel",
                      height: 36,
                      borderRadius: 8,
                      textSize: 11,
                      textWeight: FontWeight.w400,
                      textColor: ElevateColor.gray,
                      backgroundColor: const Color(0xFFF3F3F3),
                      borderColor: const Color(0xFF8B8B8B),
                      borderWidth: 1,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminManageCompany(),
                          ),
                        );
                        }
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

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 2),
      child: CustomText(
        text: text,
        fontSize: 10,
        color: const Color(0xFF777777),
        fontWeight: FontWeight.w500,
        lineHeight: 1.0,
      ),
    );
  }
}

