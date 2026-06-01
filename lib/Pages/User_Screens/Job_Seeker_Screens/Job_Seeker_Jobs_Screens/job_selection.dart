import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/company_tile.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/user_cold_email.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:elevate_app/Data_Model_Classes/api_job_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class JobSelection extends StatelessWidget {
  final ApiJobModel job;

  const JobSelection({super.key, required this.job});

  Future<void> openApply(BuildContext context) async {
    final uri = Uri.parse(job.applyUrl);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Cannot open link")));
    }
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
                ElevateHeader(),

                Padding(
                  padding: const EdgeInsets.only(top: 150.0, left: 80),
                  child: CompanyTile(
                    name: job.company,
                    location: job.location,
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
                            "Salary: ${job.salary ?? "Not disclosed"}\n"
                            "Type: ${job.jobType ?? "Full Time"}\n"
                            "Platform: ${job.platform}\n"
                            "${job.isRemote ? "Remote" : "On-site"}",
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
                        text: job.description ?? "No description available",
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
                              builder: (context) => UserColdEmail(),
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
                        onTap: () => openApply(context),
                      ),

                      const SizedBox(height: 30),
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
