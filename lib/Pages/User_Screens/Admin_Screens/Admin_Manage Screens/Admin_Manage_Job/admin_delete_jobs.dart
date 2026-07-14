import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Message_Box/messageBox.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminDeleteJobs extends StatefulWidget {
  final String jobID;
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
    required this.jobID,
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
  State<AdminDeleteJobs> createState() => _AdminDeleteJobsState();
}

class _AdminDeleteJobsState extends State<AdminDeleteJobs> {
  final FirebaseService firebaseService = FirebaseService();
  bool isDeleting = false;

  Future<void> handleDelete() async {
    setState(() => isDeleting = true);

    try {
      await firebaseService.deleteJob(widget.jobID);

      if (!mounted) return;
      Navigator.pop(context, true); // true tells caller a deletion happened

      showDialog(
        context: context,
        builder: (_) =>
            Messagebox(message: "${widget.title} deleted successfully."),
      );
    } catch (e) {
      setState(() => isDeleting = false);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => Messagebox(message: "Failed to delete job."),
      );
    }
  }

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
                      text: widget.title,
                      fontSize: widget.titleFontSize,
                      color: widget.titleColor,
                      fontWeight: widget.titleFontWeight,
                      lineHeight: widget.titleLineHeight,
                      textAlign: widget.titleTextAlign,
                      maxLines: widget.titleMaxLines,
                    ),
                    const SizedBox(height: 15),
                    // Description
                    CustomText(
                      text: widget.description,
                      fontSize: widget.descriptionFontSize,
                      color: widget.descriptionColor,
                      fontWeight: widget.descriptionFontWeight,
                      lineHeight: widget.descriptionLineHeight,
                      textAlign: widget.descriptionTextAlign,
                      maxLines: widget.descriptionMaxLines,
                    ),
                    const SizedBox(height: 40),
                    // Delete Button
                    TextButtonGradient(
                      text: isDeleting ? "Deleting..." : "Delete JOB",
                      height: 50,
                      textSize: 14,
                      textWeight: FontWeight.w400,
                      borderRadius: 50,
                      onTap: isDeleting ? () {} : handleDelete,
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
                      onTap: isDeleting ? () {} : () => Navigator.pop(context),
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
