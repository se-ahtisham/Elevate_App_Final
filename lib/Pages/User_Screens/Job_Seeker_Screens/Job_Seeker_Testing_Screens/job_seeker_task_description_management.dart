import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JobSeekerTaskDescriptionManagement extends StatelessWidget {
  final String title;
  final String? description;
  final String? topicToImprove;
  final String? suggestion;

  const JobSeekerTaskDescriptionManagement({
    super.key,
    required this.title,
    this.description,
    this.topicToImprove,
    this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevateHeader(
                title: "Elevate",
                subTitle: "Task",
                titleSize: 40,
                subtitleSize: 25,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 30,
                      left: 30,
                      bottom: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: title,
                          fontSize: 25,
                          color: ElevateColor.gray,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 5),
                        CustomText(
                          text: "Description",
                          fontSize: 18,
                          color: ElevateColor.gray,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: 340,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 214, 214, 214),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child:
                              (description == null ||
                                  description!
                                      .isEmpty) // Null assertion (not the NOT operator)(id description is emptys)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "Topics To Improve:",
                                      fontSize: 16,
                                      color: ElevateColor.gray,
                                      fontWeight: FontWeight.bold,
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: 5),
                                    CustomText(
                                      text: topicToImprove ?? "",
                                      fontSize: 12,
                                      color: ElevateColor.gray,
                                      fontWeight: FontWeight.w400,
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: 15),
                                    CustomText(
                                      text: "Suggestion:",
                                      fontSize: 16,
                                      color: ElevateColor.gray,
                                      fontWeight: FontWeight.bold,
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: 10),
                                    CustomText(
                                      text: suggestion ?? "",
                                      fontSize: 12,
                                      color: ElevateColor.gray,
                                      fontWeight: FontWeight.w400,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                )
                              : CustomText(
                                  text: description!,
                                  fontSize: 13,
                                  color: ElevateColor.gray,
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.left,
                                ),
                        ),

                        SizedBox(height: 30),
                        TextButtonGradient(
                          text: "Complete",
                          height: 50,
                          textSize: 14,
                          textWeight: FontWeight.w400,
                          borderRadius: 50,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(height: 15),
                        TexxtButton(
                          text: "Delete",
                          height: 50,
                          textSize: 14,
                          textColor: ElevateColor.gray,
                          textWeight: FontWeight.w400,
                          borderRadius: 50,
                          backgroundColor: Colors.transparent,
                          borderColor: ElevateColor.gray,
                          borderWidth: 1,
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
      ),
    );
  }
}
