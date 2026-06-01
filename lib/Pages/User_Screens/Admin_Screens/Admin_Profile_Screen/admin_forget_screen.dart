import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Drop_Down_Menu/custom_drop_down.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminForgetScreen extends StatefulWidget {
  const AdminForgetScreen({super.key});

  @override
  State<AdminForgetScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminForgetScreen> {
   TextEditingController passwordController = TextEditingController();
   TextEditingController answerController = TextEditingController();

  // For Drop Down
  String? questionValue;
  List<String> questionoptions = [
    "Write Your Hobby",
    "Write Your School",
    "Write Your DOB",
  ];

  @override
  void dispose() {
    passwordController.dispose();
    answerController.dispose();
    super.dispose();
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
              title: "Your Info",
              subTitle: "Let’s Discover Yourself",
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Security Question",
                            fontSize: 12,
                            color: ElevateColor.whitegray,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 10),
                          CustomDropDown(
                            hintText: "Write Your Hobby",
                            items: questionoptions,
                            value: questionValue,
                            hintTextSize: 11,
                            textSize: 11,
                            width: 350,
                            borderWidth: 0,
                            backgroundColor: const Color.fromARGB(
                              255,
                              235,
                              235,
                              235,
                            ),
                            onChanged: (value) {
                              setState(() {
                                questionValue = value;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 30),

                      CustomTextField(
                        hintText: "Answer",
                        hintWeight: FontWeight.w400,
                        controller: answerController,
                        cursorColor: ElevateColor.black,
                        underlineColor: ElevateColor.black,
                      ),
                      SizedBox(height: 30),
                      TextButtonGradient(
                        text: "Check",
                        height: 50,
                        textSize: 14,
                        textWeight: FontWeight.w400,
                        borderRadius: 50,
                        onTap: null,
                      ),
                      SizedBox(height: 100),
                      CustomTextField(
                        hintText: "Set New Password",
                        hintWeight: FontWeight.w400,
                        controller: passwordController,
                        cursorColor: ElevateColor.black,
                        underlineColor: ElevateColor.black,
                        obscureText: true,
                      ),
                      SizedBox(height: 30),
                      TextButtonGradient(
                        text: "Done",
                        height: 50,
                        textSize: 14,
                        textWeight: FontWeight.w400,
                        borderRadius: 50,
                         onTap: () {
    Navigator.pop(context);
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
