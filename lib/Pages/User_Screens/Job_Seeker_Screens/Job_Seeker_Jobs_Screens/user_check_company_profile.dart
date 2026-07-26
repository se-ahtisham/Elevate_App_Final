import 'package:elevate_app/Custom_Widgets/Buttons/icon_text_button.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/user_request_rating_company.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserCheckCompanyProfile extends ConsumerStatefulWidget {
  final CompanyModel company;

  const UserCheckCompanyProfile({super.key, required this.company});

  @override
  ConsumerState<UserCheckCompanyProfile> createState() => _UserCheckCompanyProfileState();
}

class _UserCheckCompanyProfileState extends ConsumerState<UserCheckCompanyProfile> {
  final _firebaseService = FirebaseService();
  String _followStatus = "None";
  bool _isFollowingLoading = false;
  bool _isApplyingEmployee = false;
  int _followersCount = 0;

  @override
  void initState() {
    super.initState();
    _followersCount = widget.company.followers.length;
    _checkFollowStatus();
  }

  Future<void> _checkFollowStatus() async {
    final myID = ref.read(authProvider).jobSeeker?.jobSeekerID;
    if (myID == null) return;
    try {
      final status = await _firebaseService.getFollowStatus(myID, widget.company.companyID);
      if (mounted) {
        setState(() {
          _followStatus = status;
        });
      }
    } catch (_) {}
  }

  Future<void> _toggleFollow() async {
    final myID = ref.read(authProvider).jobSeeker?.jobSeekerID;
    if (myID == null) return;

    setState(() => _isFollowingLoading = true);
    try {
      if (_followStatus == "Following") {
        await _firebaseService.unfollowUser(myID, widget.company.companyID, toCollection: 'companies');
        setState(() {
          _followStatus = "None";
          _followersCount = (_followersCount - 1).clamp(0, 99999);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Unfollowed ${widget.company.companyName}")),
          );
        }
     } else if (_followStatus == "None") {
  await _firebaseService.followUser(myID, widget.company.companyID, toCollection: 'companies');
  setState(() {
    _followStatus = "Pending";
  });
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Follow request sent to ${widget.company.companyName}")),
    );
  }
}
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to change follow state: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isFollowingLoading = false);
      }
    }
  }

  Future<void> _joinAsEmployee() async {
    final jobSeeker = ref.read(authProvider).jobSeeker;
    if (jobSeeker == null) return;

    setState(() => _isApplyingEmployee = true);
    try {
      final position = jobSeeker.shortDescription.isNotEmpty
          ? jobSeeker.shortDescription
          : "Employee";

      await _firebaseService.applyAsEmployee(
        jobSeeker.jobSeekerID,
        widget.company.companyID,
        position,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Employee application submitted!")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserRequestRatingCompany(
            company: widget.company,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Application failed: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isApplyingEmployee = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final logoUrl = widget.company.logo.isNotEmpty
        ? widget.company.logo
        : 'https://mir-s3-cdn-cf.behance.net/projects/404/e87f90243740647.Y3JvcCwxNTM0LDEyMDAsMzQsMA.jpg';

    final achievements = widget.company.achievementList.isNotEmpty
        ? widget.company.achievementList.join(", ")
        : "Best FinTech Startup 2024, ISO 27001 Certified";

    final strengths = widget.company.companyStrengthList.isNotEmpty
        ? widget.company.companyStrengthList.join(" • ")
        : "Innovation • Collaboration • Supportive Management • Career Growth • Learning Opportunities";

    final weaknesses = widget.company.companyWeaknessList.isNotEmpty
        ? widget.company.companyWeaknessList.join(" • ")
        : "High Workload • Tight Deadlines • Bureaucracy • Limited Benefits • Poor Documentation";

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
                const ElevateHeader(
                  title: "Explore Companies",
                  subTitle: "Explore roles from top companies",
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 20),
                  child: UserDescription(
                    imageURL: logoUrl,
                    name: widget.company.companyName,
                    shortDescription: widget.company.industry.isNotEmpty
                        ? widget.company.industry
                        : "FinTech",
                    skills: widget.company.activeJobs,
                    followers: _followersCount,
                    followings: widget.company.employeeList.length,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            text: "ABOUT US",
                            fontSize: 18,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          const Spacer(),
                          _isFollowingLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                )
                              : IconTextButton(
                                  text: _followStatus == "Following"
                                      ? "UNFOLLOW"
                                      : _followStatus == "Pending"
                                          ? "PENDING"
                                          : "FOLLOW",
                                  iconData: _followStatus == "Following"
                                      ? Icons.remove_circle_outline
                                      : Icons.add_circle_outline,
                                  backgroundColor: ElevateColor.white,
                                  iconColor: ElevateColor.lightgray,
                                  textColor: ElevateColor.gray,
                                  textWeight: FontWeight.bold,
                                  borderColor: ElevateColor.gray,
                                  borderRadius: 50,
                                  textSize: 9,
                                  onTap: _toggleFollow,
                                ),
                          const SizedBox(width: 8),
                          _isApplyingEmployee
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                )
                              : IconTextButton(
                                  text: "JOIN AS EMPLOYEE",
                                  iconData: Icons.work,
                                  backgroundColor: ElevateColor.white,
                                  iconColor: ElevateColor.lightgray,
                                  textColor: ElevateColor.gray,
                                  textWeight: FontWeight.bold,
                                  borderColor: ElevateColor.gray,
                                  borderRadius: 50,
                                  textSize: 9,
                                  onTap: _joinAsEmployee,
                                ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomText(
                        text: widget.company.description.isNotEmpty
                            ? widget.company.description
                            : "TechNova Inc. is dedicated to building secure and user-friendly financial platforms. We foster a culture of collaboration, innovation, and continuous learning.",
                        fontSize: 13,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.justify,
                        lineHeight: 1.3,
                      ),
                      const SizedBox(height: 22),
                      UserSocialmedia(
                        city: widget.company.location.split(",").first.trim(),
                        country: widget.company.location.contains(",")
                            ? widget.company.location.split(",").last.trim()
                            : "Pakistan",
                        email: widget.company.email.isNotEmpty
                            ? widget.company.email
                            : "technova@gmail.com",
                        web: widget.company.website.isNotEmpty
                            ? widget.company.website
                            : "www.technova.com",
                      ),

                      const SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Company Achievements",
                            fontSize: 18,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          const SizedBox(height: 15),
                          IconText(
                            text: achievements,
                            iconData: Icons.emoji_events_outlined,
                            iconColor: ElevateColor.lightgray,
                            iconSize: 30,
                            iconTextSpacing: 8,
                            textSize: 12,
                            textColor: ElevateColor.lightgray,
                            textWeight: FontWeight.w400,
                            lineHeight: 1.2,
                          ),
                          const SizedBox(height: 30),
                          CustomText(
                            text: "Company Strengths",
                            fontSize: 18,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            text: strengths,
                            fontSize: 12,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.left,
                            lineHeight: 1.2,
                          ),

                          const SizedBox(height: 30),
                          CustomText(
                            text: "Company Weaknesses",
                            fontSize: 18,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            text: weaknesses,
                            fontSize: 12,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.left,
                            lineHeight: 1.2,
                          ),
                        ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
