import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminDeleteJobs extends StatelessWidget {
  final String title;
  final String description;

  // Title properties
  final double titleFontSize;
  final Color? titleColor;
  final FontWeight titleFontWeight;
  final double titleLineHeight;
  final TextAlign titleTextAlign;
  final int? titleMaxLines;

  // Description properties
  final double descriptionFontSize;
  final Color? descriptionColor;
  final FontWeight descriptionFontWeight;
  final double descriptionLineHeight;
  final TextAlign descriptionTextAlign;
  final int? descriptionMaxLines;

  const AdminDeleteJobs({
    super.key,
    required this.title,
    required this.description,
    this.titleFontSize = 25,
    this.titleColor = const Color.fromARGB(255, 161, 161, 161),
    this.titleFontWeight = FontWeight.w800,
    this.titleLineHeight = 1.3,
    this.titleTextAlign = TextAlign.start,
    this.titleMaxLines,
    this.descriptionFontSize = 13,
    this.descriptionColor = Colors.black54,
    this.descriptionFontWeight = FontWeight.normal,
    this.descriptionLineHeight = 1.4,
    this.descriptionTextAlign = TextAlign.justify,
    this.descriptionMaxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            ElevateHeader(
              title: "DELETING",
              subTitle: "OPPORTUNITY",
              titleSize: 40,
              subtitleSize: 25,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    CustomText(
                      text: title,
                      fontSize: titleFontSize,
                      color: titleColor,
                      fontWeight: titleFontWeight,
                      lineHeight: titleLineHeight,
                      textAlign: titleTextAlign,
                      maxLines: titleMaxLines,
                    ),
                    const SizedBox(height: 15),
                    // Description
                    CustomText(
                      text: description,
                      fontSize: descriptionFontSize,
                      color: descriptionColor,
                      fontWeight: descriptionFontWeight,
                      lineHeight: descriptionLineHeight,
                      textAlign: descriptionTextAlign,
                      maxLines: descriptionMaxLines,
                    ),
                    const SizedBox(height: 40),
                    // Delete Button
                    TextButtonGradient(
                      text: "Delete JOB",
                      height: 50,
                      textSize: 14,
                      textWeight: FontWeight.w400,
                      borderRadius: 50,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 15),
                    // Cancel Button
                    TexxtButton(
                      text: "Cancel",
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
          ],
        ),
      ),
    );
  }
}
