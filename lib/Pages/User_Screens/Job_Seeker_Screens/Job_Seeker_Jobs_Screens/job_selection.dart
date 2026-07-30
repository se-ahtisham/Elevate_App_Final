import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/company_tile.dart';
import 'package:elevate_app/Custom_Widgets/Message_Box/job_apply_bottom_sheet.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/skill_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/user_cold_email.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobSelection extends ConsumerStatefulWidget {
  final JobPostModel jobPost;
  final String? companyEmail;
  final String companyName;

  const JobSelection({
    super.key,
    required this.jobPost,
    this.companyEmail,
    required this.companyName,
  });

  @override
  ConsumerState<JobSelection> createState() => JobSelectionState();
}

class JobSelectionState extends ConsumerState<JobSelection> {
  final firebaseService = FirebaseService();
  List<SkillModel> resolvedSkills = [];
  Map<String, double> userSkillScores = {};
  bool isLoadingSkills = true;

  @override
  void initState() {
    super.initState();
    loadRequiredSkills();
  }

  Future<void> loadRequiredSkills() async {
    final myID = ref.read(authProvider).jobSeeker?.jobSeekerID;
    try {
      final allSkills = await firebaseService.listAllSkills();
      final requiredSkillIDs = widget.jobPost.requiredSkills;

      final matched = allSkills
          .where((s) => requiredSkillIDs.contains(s.skillID))
          .toList();

      Map<String, double> scores = {};
      if (myID != null) {
        scores = await firebaseService.getBestPassedScoresBySkill(myID);
      }

      if (!mounted) return;
      setState(() {
        resolvedSkills = matched;
        userSkillScores = scores;
        isLoadingSkills = false;
      });
    } catch (_) {
      if (mounted) setState(() => isLoadingSkills = false);
    }
  }

  void _showApplyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return JobApplyBottomSheet(
          jobTitle: widget.jobPost.title,
          companyName: widget.companyName,
          companyEmail: widget.companyEmail,
        );
      },
    );
  }

  String getSkillTierBadge(String skillID) {
    final score = userSkillScores[skillID];
    if (score == null) return "Not Passed";
    final tier = FirebaseService.tierForScore(score);
    switch (tier) {
      case 'Gold':
        return "🥇 Gold (${score.toStringAsFixed(0)}%)";
      case 'Silver':
        return "🥈 Silver (${score.toStringAsFixed(0)}%)";
      case 'Bronze':
        return "🥉 Bronze (${score.toStringAsFixed(0)}%)";
      default:
        return "Passed (${score.toStringAsFixed(0)}%)";
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
                const ElevateHeader(title: "", subTitle: ""),
                Padding(
                  padding: const EdgeInsets.only(top: 150.0, left: 80),
                  child: CompanyTile(
                    name: widget.companyName,
                    location: widget.jobPost.location,
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

            /// CONTENT
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

                      const CustomText(
                        text: "Job Details",
                        fontSize: 19,
                        color: Color.fromARGB(255, 99, 99, 99),
                        fontWeight: FontWeight.w700,
                      ),

                      const SizedBox(height: 15),

                      CustomText(
                        text:
                            "Salary: ${widget.jobPost.salary.isNotEmpty ? widget.jobPost.salary : "Not disclosed"}\n"
                            "Type: ${widget.jobPost.jobType.isNotEmpty ? widget.jobPost.jobType : "Full Time"}\n"
                            "Platform: Elevate\n"
                            "Location: ${widget.jobPost.location}",
                        fontSize: 12,
                        color: const Color.fromARGB(255, 99, 99, 99),
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.left,
                        lineHeight: 1.5,
                      ),

                      const SizedBox(height: 25),

                      // Required Skills Section
                      const CustomText(
                        text: "Required Skills & Eligibility",
                        fontSize: 19,
                        color: Color.fromARGB(255, 99, 99, 99),
                        fontWeight: FontWeight.w700,
                      ),

                      const SizedBox(height: 12),

                      isLoadingSkills
                          ? const SizedBox(
                              height: 30,
                              child: CircularProgressIndicator(color: Colors.black),
                            )
                          : resolvedSkills.isEmpty
                              ? const Text(
                                  "No specific skill requirements listed.",
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                )
                              : Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: resolvedSkills.map((skill) {
                                    final badgeText = getSkillTierBadge(skill.skillID);
                                    final isPassed = userSkillScores.containsKey(skill.skillID);
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isPassed
                                            ? Colors.black
                                            : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isPassed
                                              ? Colors.black
                                              : Colors.grey.shade300,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            skill.skillName,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: isPassed
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "($badgeText)",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isPassed
                                                  ? Colors.white70
                                                  : Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),

                      const SizedBox(height: 25),

                      const CustomText(
                        text: "Description",
                        fontSize: 19,
                        color: Color.fromARGB(255, 99, 99, 99),
                        fontWeight: FontWeight.w700,
                      ),

                      const SizedBox(height: 15),

                      CustomText(
                        text: widget.jobPost.description.isNotEmpty
                            ? widget.jobPost.description
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
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => UserColdEmail(
                                jobTitle: widget.jobPost.title,
                                companyName: widget.companyName,
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

