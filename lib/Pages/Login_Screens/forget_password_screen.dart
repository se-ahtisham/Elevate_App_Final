import 'package:elevate_app/Animation/slide_left_route.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Drop_Down_Menu/custom_drop_down.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Pages/Login_Screens/login_screen.dart';
// import 'package:elevate_app/Pages/Login_Screens/user_select.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late TextEditingController answerController;
  late TextEditingController newPasswordController;

  String? selectedQuestion;

  List<String> questions = [
    "What's your hobby?",
    "Your first school?",
    "Favorite food?",
  ];

  @override
  void initState() {
    super.initState();
    answerController = TextEditingController();
    newPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    answerController.dispose();
    newPasswordController.dispose();
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
            Stack(
              children: [
                ElevateHeader(
                  title: "Lost Access?",
                  titleSize: 30,
                  subTitle: "Let’s reconnect you with your account in seconds.",
                  subtitleSize: 14,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70, left: 250),
                  child: TexxtButton(
                    text: "Go To Login",
                    textSize: 12,
                    textColor: Colors.black,
                    backgroundColor: Colors.white,
                    borderRadius: 20,
                    height: 40,
                    width: 150,
                    onTap: () { Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen())); },
                  ),
                ),
              ],
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),

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

                      SizedBox(height: 25),

                      TextButtonGradient(
                        text: "Check",
                        height: 50,
                        textSize: 16,
                        textWeight: FontWeight.w500,
                        borderRadius: 30,
            
                      ),

                      SizedBox(height: 40),

                      CustomText(
                        text: "Set New Password",
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
                            controller: newPasswordController,
                            cursorColor: ElevateColor.black,
                            underlineColor: Colors.transparent,
                            obscureText: true,
                          ),
                        ),
                      ),

                      SizedBox(height: 25),

                      TextButtonGradient(
                        text: "Done",
                        height: 50,
                        textSize: 16,
                        textWeight: FontWeight.w500,
                        borderRadius: 30,
                        onTap: () { Navigator.pushReplacement(context, SlideLeftRoute(page: LoginScreen())); },
                      ),

                      SizedBox(height: 20),
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
