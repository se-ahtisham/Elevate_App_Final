import 'package:elevate_app/Animation/slide_left_route.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Drop_Down_Menu/custom_drop_down.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Pages/Login_Screens/login_screen.dart';
import 'package:elevate_app/Pages/Login_Screens/user_select.dart';
// import 'package:elevate_app/Pages/admin_main.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController answerController;

  String? selectedQuestion;
  String? selectedRole;

  List<String> questions = [
    "What's your hobby?",
    "Your first school?",
    "Favorite food?",
  ];

  List<String> roleOptions = ["Job Seeker", "Company"];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    answerController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElevateColor.white,
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            ElevateHeader(
              title: "Sign Up to your",
              titleSize: 30,
              subTitle: "Account",
              subtitleSize: 20,
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),

                      CustomText(
                        text: "Name",
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: CustomTextField(
                            hintText: "ahtisham",
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
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: CustomTextField(
                            hintText: "ahtisham@gmail.com",
                            controller: emailController,
                            cursorColor: ElevateColor.black,
                            underlineColor: Colors.transparent,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      CustomText(
                        text: "Set Password",
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: CustomTextField(
                            hintText: "**************",
                            controller: passwordController,
                            cursorColor: ElevateColor.black,
                            underlineColor: Colors.transparent,
                            obscureText: true,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      CustomText(
                        text: "Security Question",
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.left,
                      ),

                      SizedBox(height: 8),

                      CustomDropDown(
                        hintText: "What's your hobby?",
                        items: questions,
                        value: selectedQuestion,
                        width: double.infinity,
                        borderWidth: 1,
                        backgroundColor: const Color(0xffF2F2F2),
                        onChanged: (value) {
                          setState(() {
                            selectedQuestion = value;
                          });
                        },
                      ),

                      SizedBox(height: 20),

                      CustomText(
                        text: "Answer",
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: CustomTextField(
                            hintText: "Coding",
                            controller: answerController,
                            cursorColor: ElevateColor.black,
                            underlineColor: Colors.transparent,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      CustomText(
                        text: "Join as",
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.left,
                      ),

                      SizedBox(height: 8),

                      CustomDropDown(
                        hintText: "Job Seeker / Company",
                        items: roleOptions,
                        value: selectedRole,
                        width: double.infinity,
                        borderWidth: 1,
                        backgroundColor: const Color(0xffF2F2F2),
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                          });
                        },
                      ),

                      SizedBox(height: 25),

                      TextButtonGradient(
                        text: "Register",
                        height: 50,
                        textSize: 16,
                        textWeight: FontWeight.w500,
                        borderRadius: 30,
                        onTap: () {
                          /*
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserSelect(),
                            ),
                          );*/
                        },
                      ),

                      SizedBox(height: 20),

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
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            SlideLeftRoute(page: LoginScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
