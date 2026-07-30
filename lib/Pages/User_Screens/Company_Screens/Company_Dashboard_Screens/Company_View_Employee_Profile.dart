import "package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart";
import "package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart";
import "package:elevate_app/Custom_Widgets/Header/elevate_header.dart";
import "package:elevate_app/Custom_Widgets/Text/custom_text.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_education.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_skill.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_work.dart";
import "package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/company_message_screen.dart";
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
  late Future<JobSeekerModel?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _firebaseService.getJobSeeker(widget.jobSeekerID);
  }

  void _removeEmployee() async {
    await _firebaseService.terminateEmployee(widget.employeeID);
    if (mounted) {
      Navigator.pop(context);
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
                    ElevateHeader(
                      title: "Your Digital Identity",
                      subTitle: "Account Control Center",
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
                              TextButtonGradient(
                                text: "Follow",
                                height: 40,
                                width: 160,
                                textSize: 14,
                                textWeight: FontWeight.w400,
                                borderRadius: 50,
                                onTap: () {},
                              ),
                              SizedBox(width: 20),
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
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CompanyMessageScreen(
                                              receiverId: seeker.jobSeekerID,
                                              receiverName: seeker.name,
                                              receiverImage: seeker.profilePic,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          TexxtButton(
                            text: "Remove Employee",
                            height: 40,
                            width: 350,
                            textSize: 14,
                            textColor: ElevateColor.gray,
                            textWeight: FontWeight.w400,
                            borderRadius: 50,
                            backgroundColor: Colors.transparent,
                            borderColor: ElevateColor.gray,
                            borderWidth: 1,
                            onTap: _removeEmployee,
                          ),
                          SizedBox(height: 30),
                          CustomText(
                            text: "ABOUT ME",
                            fontSize: 20,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          SizedBox(height: 12),
                          CustomText(
                            text: seeker.about.isNotEmpty
                                ? seeker.about
                                : "No about info provided.",
                            fontSize: 13,
                            color: ElevateColor.whitegray,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.justify,
                            lineHeight: 1.3,
                          ),
                          SizedBox(height: 22),
                          UserSocialmedia(
                            city: seeker.location,
                            country: "",
                            email: seeker.email,
                            phone: "",
                          ),

                          SizedBox(height: 22),
                          Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 233, 233, 233),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: "EXPERIENCE LEVEL",
                                    fontSize: 20,
                                    color: ElevateColor.lightgray,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.left,
                                    lineHeight: 1.0,
                                  ),
                                  SizedBox(height: 8),
                                  CustomText(
                                    text: seeker.experienceLevel,
                                    fontSize: 12,
                                    color: ElevateColor.lightgray,
                                    fontWeight: FontWeight.w300,
                                    textAlign: TextAlign.left,
                                    lineHeight: 1.0,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 22),
                          if (seeker.education.isNotEmpty) ...[
                            CustomText(
                              text: "EDUCATION",
                              fontSize: 20,
                              color: ElevateColor.lightgray,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.left,
                              lineHeight: 1.0,
                            ),
                            SizedBox(height: 15),
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
                            SizedBox(height: 22),
                          ],

                          CustomText(
                            text: "SKILL",
                            fontSize: 20,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          SizedBox(height: 15),
                          Column(
                            children: [
                              UserSkill(
                                title: 'Java Development',
                                subtitle: 'Experienced Coding',
                                imagePath:
                                    'https://ui-avatars.com/api/?name=Java&background=random&color=fff&size=128',
                                year: '2025',
                              ),
                            ],
                          ),
                          SizedBox(height: 22),

                          if (seeker.jobExperience.isNotEmpty) ...[
                            CustomText(
                              text: "WORK",
                              fontSize: 20,
                              color: ElevateColor.lightgray,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.left,
                              lineHeight: 1.0,
                            ),
                            SizedBox(height: 15),
                            Column(
                              children: seeker.jobExperience.map((work) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: UserWork(
                                    title: work.jobTitle,
                                    subtitle: work.company,
                                    iconData: Icons.work_outline,
                                    startDate: work.from,
                                    endDate: work.to.isEmpty ? null : work.to,
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 40),
                          ],

                          TextButtonGradient(
                            text: "View Portfolio",
                            height: 50,
                            textSize: 14,
                            textWeight: FontWeight.w400,
                            borderRadius: 50,
                            onTap: () {},
                          ),
                          SizedBox(height: 15),
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

