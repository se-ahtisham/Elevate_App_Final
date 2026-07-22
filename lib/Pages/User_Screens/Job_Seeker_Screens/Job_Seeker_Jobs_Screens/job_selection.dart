import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/company_tile.dart';
import 'package:elevate_app/Custom_Widgets/Message_Box/job_apply_bottom_sheet.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/user_cold_email.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JobSelection extends StatelessWidget {
  final JobPostModel jobPost;
  final String? companyEmail;
  final String companyName;

  const JobSelection({
    super.key,
    required this.jobPost,
    this.companyEmail,
    required this.companyName,
  });

  void _showApplyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return JobApplyBottomSheet(
          jobTitle: jobPost.title,
          companyName: companyName,
          companyEmail: companyEmail,
        );
      },
    );
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
            /// HEADER + COMPANY TILE
            Stack(
              children: [
                const ElevateHeader(title: "", subTitle: ""),
                Padding(
                  padding: const EdgeInsets.only(top: 150.0, left: 80),
                  child: CompanyTile(
                    name: companyName,
                    location: jobPost.location,
                    tileHeight: 180,
                    tileWidth: 250,
                    imageSize: 85,
                    spacingBetweenImageAndText: 12,
                    nameFontSize: 16,
                    nameColor: Colors.black,
                    nameFontWeight: FontWeight.bold,
                    nameLineHeight: 1.2,
                    descriptionFontSize: 12,
                    descriptionColor: Colors.grey,
                    descriptionFontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),

            /// CONTENT (FIXED)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),

                      CustomText(
                        text: "Job Details",
                        fontSize: 19,
                        color: const Color.fromARGB(255, 99, 99, 99),
                        fontWeight: FontWeight.w700,
                      ),

                      const SizedBox(height: 15),

                      CustomText(
                        text:
                            "Salary: ${jobPost.salary.isNotEmpty ? jobPost.salary : "Not disclosed"}\n"
                            "Type: ${jobPost.jobType.isNotEmpty ? jobPost.jobType : "Full Time"}\n"
                            "Platform: Elevate\n"
                            "Location: ${jobPost.location}",
                        fontSize: 12,
                        color: const Color.fromARGB(255, 99, 99, 99),
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.left,
                        lineHeight: 1.5,
                      ),

                      const SizedBox(height: 25),

                      CustomText(
                        text: "Description",
                        fontSize: 19,
                        color: const Color.fromARGB(255, 99, 99, 99),
                        fontWeight: FontWeight.w700,
                      ),

                      const SizedBox(height: 15),

                      CustomText(
                        text: jobPost.description.isNotEmpty
                            ? jobPost.description
                            : "No description available",
                        fontSize: 12,
                        color: const Color.fromARGB(255, 99, 99, 99),
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.justify,
                        lineHeight: 1.5,
                      ),

                      const SizedBox(height: 40),

                      /// QUICK MAIL
                      TexxtButton(
                        text: "Quick Mail",
                        height: 50,
                        textSize: 14,
                        textColor: ElevateColor.gray,
                        textWeight: FontWeight.w400,
                        borderRadius: 50,
                        backgroundColor: Colors.transparent,
                        borderColor: ElevateColor.gray,
                        borderWidth: 1,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserColdEmail(
                                jobTitle: jobPost.title,
                                companyName: companyName,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 15),

                      /// APPLY NOW
                      TextButtonGradient(
                        text: "Apply Now",
                        height: 50,
                        textSize: 14,
                        textWeight: FontWeight.w400,
                        borderRadius: 50,
                        onTap: () => _showApplyBottomSheet(context),
                      ),

                      const SizedBox(height: 30),

                      TexxtButton(
                        text: "Back",
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
    );
  }
}
