import "package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart";
import "package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart";
import "package:elevate_app/Custom_Widgets/Header/elevate_header.dart";
import "package:elevate_app/Custom_Widgets/Text/custom_text.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_education.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_work.dart";
import "package:elevate_app/Database/Online_Database/auth_service.dart";
import "package:elevate_app/Database/Online_Database/chat_service.dart";
import "package:elevate_app/Pages/Shared_Screens/chat_room_screen.dart";
import "package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/company_portfolio_check.dart";
import "package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/company_view_user_post.dart";
import "package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';

class CompanyViewEmployeeProfile extends StatefulWidget {
  final String jobSeekerID;
  final String employeeID;

  const CompanyViewEmployeeProfile({
    super.key,
    required this.jobSeekerID,
    required this.employeeID,
  });

  @override
  State<CompanyViewEmployeeProfile> createState() =>
      _CompanyViewEmployeeProfileState();
}

class _CompanyViewEmployeeProfileState
    extends State<CompanyViewEmployeeProfile> {
  final FirebaseService _firebaseService = FirebaseService();
  final AuthService _authService = AuthService();
  late Future<JobSeekerModel?> _profileFuture;
  bool _isRemoving = false;

  @override
  void initState() {
    super.initState();
    _profileFuture = _firebaseService.getJobSeeker(widget.jobSeekerID);
  }

  Future<void> _removeEmployee() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Remove Employee"),
        content: const Text("Are you sure you want to remove this employee from your team?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isRemoving = true);
    try {
      await _firebaseService.terminateEmployee(widget.employeeID);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Employee removed successfully.")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isRemoving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to remove employee: $e")),
        );
      }
    }
  }

  Future<void> _openChat(JobSeekerModel seeker) async {
    final currentUserId = _authService.currentUser?.uid ?? '';
    if (currentUserId.isEmpty) return;

    final myCompany = await _firebaseService.getCompany(currentUserId);
    final myName = myCompany?.companyName ?? 'Company';
    final myAvatar = myCompany?.logo ?? '';

    final chatID = await ChatService().getOrCreateChat(
      myID: currentUserId,
      myName: myName,
      myAvatar: myAvatar,
      otherID: seeker.jobSeekerID,
      otherName: seeker.name,
      otherAvatar: seeker.profilePic,
    );

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatRoomScreen(
          chatID: chatID,
          otherUserName: seeker.name,
          otherUserAvatar: seeker.profilePic,
        ),
      ),
    );
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
          child: FutureBuilder<JobSeekerModel?>(
            future: _profileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data == null) {
                return const Center(child: Text('Profile not found'));
              }

              final seeker = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const ElevateHeader(
                      title: "Employee Profile",
                      subTitle: "Working Team Member",
                      showBackButton: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 20),
                      child: UserDescription(
                        imageURL: seeker.profilePic.isNotEmpty
                            ? seeker.profilePic
                            : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(seeker.name.isNotEmpty ? seeker.name : "User")}&background=random&color=fff&size=128',
                        name: seeker.name,
                        shortDescription: seeker.shortDescription,
                        skills: seeker.skillCount,
                        followers: seeker.followers.length,
                        followings: seeker.following.length,
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
                                  textSize: 14,
                                  textColor: ElevateColor.gray,
                                  textWeight: FontWeight.w400,
                                  borderRadius: 50,
                                  backgroundColor: Colors.transparent,
                                  borderColor: ElevateColor.gray,
                                  borderWidth: 1,
                                  onTap: () => _openChat(seeker),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          TexxtButton(
                            text: _isRemoving ? "Removing..." : "Remove Employee",
                            height: 40,
                            width: 350,
                            textSize: 14,
                            textColor: Colors.red.shade700,
                            textWeight: FontWeight.w600,
                            borderRadius: 50,
                            backgroundColor: Colors.red.shade50,
                            borderColor: Colors.red.shade200,
                            borderWidth: 1,
                            onTap: _isRemoving ? () {} : _removeEmployee,
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
                            text: seeker.about.isNotEmpty
                                ? seeker.about
                                : "No bio available.",
                            fontSize: 13,
                            color: ElevateColor.whitegray,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.justify,
                            lineHeight: 1.3,
                          ),
                          const SizedBox(height: 22),
                          UserSocialmedia(
                            city: seeker.location,
                            country: "",
                            email: seeker.email,
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
                                  CustomText(
                                    text: "EXPERIENCE LEVEL",
                                    fontSize: 20,
                                    color: ElevateColor.lightgray,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                    lineHeight: 1.0,
                                  ),
                                  const SizedBox(height: 8),
                                  CustomText(
                                    text: seeker.experienceLevel.isNotEmpty
                                        ? seeker.experienceLevel
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
                          if (seeker.education.isNotEmpty) ...[
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
                              children: seeker.education.map((edu) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: UserEducation(
                                    text: edu.title,
                                    subText: edu.school,
                                    iconData: Icons.school_outlined,
                                    iconSize: 25,
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 22),
                          ],

                          if (seeker.jobExperience.isNotEmpty) ...[
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
                              children: seeker.jobExperience.map((work) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: UserWork(
                                    title: work.jobTitle,
                                    subtitle: work.company,
                                    iconData: Icons.work_outline,
                                    startDate: work.from,
                                    endDate: work.to.isEmpty ? "Present" : work.to,
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 40),
                          ],

                          TextButtonGradient(
                            text: "View Portfolio",
                            height: 50,
                            textSize: 14,
                            textWeight: FontWeight.w400,
                            borderRadius: 50,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompanyPortfolioCheck(
                                    jobSeekerID: seeker.jobSeekerID,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompanyViewUserPost(
                                    authorID: seeker.jobSeekerID,
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
              );
            },
          ),
        ),
      ),
    );
  }
}
