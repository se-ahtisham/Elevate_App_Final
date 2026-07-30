import "package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart";
import "package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart";
import "package:elevate_app/Custom_Widgets/Header/elevate_header.dart";
import "package:elevate_app/Custom_Widgets/Text/custom_text.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_education.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_work.dart";
import "package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart";
import "package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart";
import "package:elevate_app/Pages/Shared_Screens/chat_room_screen.dart";
import "package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/company_portfolio_check.dart";
import "package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/company_view_user_post.dart";
import "package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

import 'package:elevate_app/Database/Online_Database/auth_service.dart';
import 'package:elevate_app/Database/Online_Database/chat_service.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';

class CompanyViewAppliedCandidateProfileScreen extends StatelessWidget {
  final JobSeekerModel candidate;
  final JobPostModel job;

  const CompanyViewAppliedCandidateProfileScreen({
    super.key,
    required this.candidate,
    required this.job,
  });
  Future<void> _onMessageTap(BuildContext context) async {
    final authService = AuthService();
    final firebaseService = FirebaseService();

    final companyID = authService.currentUser?.uid ?? '';
    if (companyID.isEmpty) return;

    final company = await firebaseService.getCompany(companyID);
    final myName = company?.companyName ?? 'Company';
    final myAvatar = company?.logo ?? '';

    final otherAvatar = candidate.profilePic.isNotEmpty
        ? candidate.profilePic
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(candidate.name)}&background=random&color=fff&size=128';

    try {
      final chatID = await ChatService().getOrCreateChat(
        myID: companyID,
        myName: myName,
        myAvatar: myAvatar,
        otherID: candidate.jobSeekerID,
        otherName: candidate.name,
        otherAvatar: otherAvatar,
      );
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => ChatRoomScreen(
            chatID: chatID,
            otherUserName: candidate.name,
            otherUserAvatar: otherAvatar,
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open chat. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ElevateHeader(
                  title: "User Digital Identity",
                  subTitle: "Account Control Center",
                  showBackButton: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 20),
                  child: UserDescription(
                    imageURL: candidate.profilePic.isNotEmpty
                        ? candidate.profilePic
                        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(candidate.name.isNotEmpty ? candidate.name : "User")}&background=random&color=fff&size=128',
                    name: candidate.name,
                    shortDescription: candidate.shortDescription,
                    skills: candidate.skillCount,
                    followers: candidate.followers.length,
                    followings: candidate.following.length,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TexxtButton(
                              text: "Message",
                              height: 40,
                              width: 80,
                              textSize: 14,
                              textColor: ElevateColor.gray,
                              textWeight: FontWeight.w400,
                              borderRadius: 50,
                              backgroundColor: Colors.transparent,
                              borderColor: ElevateColor.gray,
                              borderWidth: 1,
                              onTap: () => _onMessageTap(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      CustomText(
                        text: "ABOUT USER",
                        fontSize: 20,
                        color: ElevateColor.lightgray,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        lineHeight: 1.0,
                      ),
                      const SizedBox(height: 12),
                      CustomText(
                        text: candidate.about.isNotEmpty
                            ? candidate.about
                            : "No bio available.",
                        fontSize: 13,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.justify,
                        lineHeight: 1.3,
                      ),
                      const SizedBox(height: 22),
                      UserSocialmedia(
                        city: candidate.location,
                        country: "",
                        email: candidate.email,
                        phone: "",
                      ),

                      const SizedBox(height: 22),
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 240, 240, 240),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color.fromARGB(255, 173, 173, 173),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CustomText(
                                text: "EXPERIENCE LEVEL",
                                fontSize: 20,
                                color: ElevateColor.lightgray,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.center,
                                lineHeight: 1.0,
                              ),
                              const SizedBox(height: 8),
                              CustomText(
                                text: candidate.experienceLevel.isNotEmpty
                                    ? candidate.experienceLevel
                                    : "Not specified",
                                fontSize: 12,
                                color: ElevateColor.lightgray,
                                fontWeight: FontWeight.w300,
                                textAlign: TextAlign.center,
                                lineHeight: 1.0,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),
                      const CustomText(
                        text: "SKILLS & TESTS",
                        fontSize: 20,
                        color: ElevateColor.lightgray,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        lineHeight: 1.0,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 240, 240, 240),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    173,
                                    173,
                                    173,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.verified_outlined,
                                    size: 26,
                                    color: ElevateColor.lightgray,
                                  ),
                                  const SizedBox(height: 4),
                                  CustomText(
                                    text: '${candidate.passedResultIDs.length}',
                                    fontSize: 18,
                                    color: ElevateColor.lightgray,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                    lineHeight: 1.0,
                                  ),
                                  const CustomText(
                                    text: 'Skills Passed',
                                    fontSize: 11,
                                    color: ElevateColor.lightgray,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.center,
                                    lineHeight: 1.2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 240, 240, 240),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    173,
                                    173,
                                    173,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.military_tech_outlined,
                                    size: 26,
                                    color: ElevateColor.lightgray,
                                  ),
                                  const SizedBox(height: 4),
                                  CustomText(
                                    text: '${candidate.totalBadgesEarned}',
                                    fontSize: 18,
                                    color: ElevateColor.lightgray,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                    lineHeight: 1.0,
                                  ),
                                  const CustomText(
                                    text: 'Badges Earned',
                                    fontSize: 11,
                                    color: ElevateColor.lightgray,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.center,
                                    lineHeight: 1.2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 240, 240, 240),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    173,
                                    173,
                                    173,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.work_outline,
                                    size: 26,
                                    color: ElevateColor.lightgray,
                                  ),
                                  const SizedBox(height: 4),
                                  CustomText(
                                    text: '${candidate.totalTestsTaken}',
                                    fontSize: 18,
                                    color: ElevateColor.lightgray,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                    lineHeight: 1.0,
                                  ),
                                  const CustomText(
                                    text: 'Tests Taken',
                                    fontSize: 11,
                                    color: ElevateColor.lightgray,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.center,
                                    lineHeight: 1.2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),
                      CustomText(
                        text: "EDUCATION",
                        fontSize: 20,
                        color: ElevateColor.lightgray,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        lineHeight: 1.0,
                      ),

                      const SizedBox(height: 15),
                      Column(
                        children: candidate.education.isEmpty
                            ? [const Text("No education listed.")]
                            : candidate.education
                                  .map(
                                    (edu) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 15.0,
                                      ),
                                      child: UserEducation(
                                        text: edu.title,
                                        subText: edu.school,
                                        iconData: Icons.school_outlined,
                                        iconSize: 25,
                                      ),
                                    ),
                                  )
                                  .toList(),
                      ),

                      const SizedBox(height: 22),
                      CustomText(
                        text: "WORK",
                        fontSize: 20,
                        color: ElevateColor.lightgray,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        lineHeight: 1.0,
                      ),

                      const SizedBox(height: 15),
                      Column(
                        children: candidate.jobExperience.isEmpty
                            ? [const Text("No work experience listed.")]
                            : candidate.jobExperience
                                  .map(
                                    (exp) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 15.0,
                                      ),
                                      child: UserWork(
                                        title: exp.jobTitle,
                                        subtitle: exp.company,
                                        iconData: Icons.work_outline,
                                        startDate: exp.from,
                                        endDate: exp.to.isNotEmpty
                                            ? exp.to
                                            : "Present",
                                      ),
                                    ),
                                  )
                                  .toList(),
                      ),

                      const SizedBox(height: 40),
                      TextButtonGradient(
                        text: "View Portfolio",
                        height: 50,
                        textSize: 14,
                        textWeight: FontWeight.w400,
                        borderRadius: 50,
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => CompanyPortfolioCheck(
                                jobSeekerID: candidate.jobSeekerID,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      TexxtButton(
                        text: "View Posts",
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
                              builder: (context) => CompanyViewUserPost(
                                authorID: candidate.jobSeekerID,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
