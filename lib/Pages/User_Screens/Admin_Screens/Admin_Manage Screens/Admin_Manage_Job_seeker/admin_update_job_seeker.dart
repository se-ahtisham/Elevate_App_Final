import 'package:elevate_app/Custom_Widgets/Buttons/contain_icon_text_button.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Drop_Down_Menu/custom_drop_down.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description_short.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminUpdateJobSeeker extends StatefulWidget {
  const AdminUpdateJobSeeker({super.key});

  @override
  State<AdminUpdateJobSeeker> createState() => _AdminUpdateJobSeekerState();
}

class _AdminUpdateJobSeekerState extends State<AdminUpdateJobSeeker> {
  TextEditingController nameController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  TextEditingController aboutusController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  // For Drop Down
  String? questionValue;
  List<String> questionoptions = [
    "Write Your Hobby",
    "Write Your School",
    "Write Your DOB",
  ];

  @override
  void dispose() {
    nameController.dispose();
    answerController.dispose();
    aboutusController.dispose();
    locationController.dispose();
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
            ElevateHeader(title: "User Info", subTitle: "Let’s Discover User"),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 20),
              child: UserDescription(
                imageURL:
                    'https://avatars.githubusercontent.com/u/159082885?v=4',
                name: "Muhammad Ahtisham",
                shortDescription: "Backend Developer",
                skills: 10,
                followers: 238,
                followings: 101,
              ),
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
                            text: "Name",
                            fontSize: 13,
                            color: ElevateColor.whitegray,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: 350,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: const Color.fromARGB(255, 75, 75, 75),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CustomTextField(
                                hintText: "Ahtisham",
                                hintWeight: FontWeight.w400,
                                controller: nameController,
                                cursorColor: ElevateColor.black,
                                underlineColor: Colors.transparent,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          CustomText(
                            text: "Security Question",
                            fontSize: 13,
                            color: ElevateColor.whitegray,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 5),
                          CustomDropDown(
                            hintText: "Write Your Hobby",
                            items: questionoptions,
                            value: questionValue,
                            hintTextSize: 11,
                            textSize: 11,
                            width: 350,
                            height: 40,
                            borderWidth: 0,
                            borderColor: const Color.fromARGB(255, 75, 75, 75),
                            backgroundColor: Colors.transparent,
                            onChanged: (value) {
                              setState(() {
                                questionValue = value;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      CustomText(
                        text: "Answer",
                        fontSize: 13,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        width: 350,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: const Color.fromARGB(255, 75, 75, 75),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextField(
                            hintText: "Coding",
                            hintWeight: FontWeight.w400,
                            controller: answerController,
                            cursorColor: ElevateColor.black,
                            underlineColor: Colors.transparent,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      CustomText(
                        text: "About User",
                        fontSize: 13,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        width: 350,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: const Color.fromARGB(255, 75, 75, 75),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextField(
                            hintText: "About User",
                            hintWeight: FontWeight.w400,
                            controller: aboutusController,
                            cursorColor: ElevateColor.black,
                            underlineColor: Colors.transparent,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      CustomText(
                        text: "User Location",
                        fontSize: 13,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        width: 350,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: const Color.fromARGB(255, 75, 75, 75),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CustomTextField(
                            hintText: "Lahore",
                            hintWeight: FontWeight.w400,
                            controller: locationController,
                            cursorColor: ElevateColor.black,
                            underlineColor: Colors.transparent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      ContainIconTextButton(
                        text: "Experience",
                        backgroundColor: Colors.grey.shade200,
                        textColor: Colors.black54,
                        iconColor: Colors.black54,
                        height: 50,
                        textSize: 12,
                        iconContainerSize: 20,
                        iconSize: 13,
                        borderRadius: 15,
                        onTap: () {
                          print("Clicked");
                        },
                      ),

                      SizedBox(height: 25),
                      ContainIconTextButton(
                        text: "Education",
                        backgroundColor: Colors.grey.shade200,
                        textColor: Colors.black54,
                        iconColor: Colors.black54,
                        height: 50,
                        textSize: 12,
                        iconContainerSize: 20,
                        iconSize: 13,
                        borderRadius: 15,
                        onTap: () {
                          print("Clicked");
                        },
                      ),

                      SizedBox(height: 30),
                      TextButtonGradient(
                        text: "Update",
                        height: 50,
                        textSize: 14,
                        textWeight: FontWeight.w400,
                        borderRadius: 50,
                       onTap: () {
    Navigator.pop(context);
  },
                      ),
                      SizedBox(height: 20),
                      TexxtButton(
                        text: "Cancel",
                        height: 50,
                        textSize: 14,
                        textWeight: FontWeight.w400,
                        textColor: Colors.black,
                        backgroundColor: Colors.transparent,
                        borderRadius: 50,
                        borderColor: Colors.black,
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
