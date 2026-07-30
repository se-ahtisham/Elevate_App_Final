import "dart:async";

import "package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart";
import "package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart";
import "package:elevate_app/Custom_Widgets/Header/elevate_header.dart";
import "package:elevate_app/Custom_Widgets/Text/custom_text.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_education.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_work.dart";
import "package:elevate_app/Pages/Shared_Screens/chat_room_screen.dart";
import "package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/company_portfolio_check.dart";
import "package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/company_view_user_post.dart";
import "package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

import 'package:elevate_app/Database/Online_Database/auth_service.dart';
import 'package:elevate_app/Database/Online_Database/chat_service.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/badge_model.dart';

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

  bool _badgesLoading = false;
  List<BadgeModel> _earnedBadges = [];

  bool _isRemoving = false;

  // Same fixed cloud badge images used on the job seeker's own profile —
  // every badge of a given level shares one image, keyed by level.
  static const String _bronzeCloudUrl =
      'https://firebasestorage.googleapis.com/v0/b/elevate-988ab.firebasestorage.app/o/badge_images%2Fbronze.png?alt=media&token=116cd0ca-d646-430a-8246-dfff9d29b673';
  static const String _silverCloudUrl =
      'https://firebasestorage.googleapis.com/v0/b/elevate-988ab.firebasestorage.app/o/badge_images%2Fsilver.png?alt=media&token=8ace9945-0206-4491-b175-db75e70b9ff7';
  static const String _goldCloudUrl =
      'https://firebasestorage.googleapis.com/v0/b/elevate-988ab.firebasestorage.app/o/badge_images%2Fgold.png?alt=media&token=8fa4f2b5-07f5-4b84-a943-02abb5989d72';

  String _getBadgeImageUrl(BadgeModel badge) {
    switch (badge.badgeLevel.toLowerCase()) {
      case 'gold':
        return _goldCloudUrl;
      case 'silver':
        return _silverCloudUrl;
      case 'bronze':
      default:
        return _bronzeCloudUrl;
    }
  }

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<JobSeekerModel?> _loadProfile() async {
    final seeker = await _firebaseService.getJobSeeker(widget.jobSeekerID);
    if (seeker != null) {
      unawaited(_loadBadges(seeker));
    }
    return seeker;
  }

  Future<void> _loadBadges(JobSeekerModel seeker) async {
    if (!mounted) return;
    setState(() => _badgesLoading = true);

    final List<BadgeModel> badges = [];
    for (final badgeID in seeker.earnedBadges) {
      final badge = await _firebaseService.getBadgeById(badgeID);
      if (badge != null) badges.add(badge);
    }

    if (!mounted) return;
    setState(() {
      _earnedBadges = badges;
      _badgesLoading = false;
    });
  }

  Future<void> _onMessageTap(JobSeekerModel seeker) async {
    final companyID = _authService.currentUser?.uid ?? '';
    if (companyID.isEmpty) return;

    final company = await _firebaseService.getCompany(companyID);
    final myName = company?.companyName ?? 'Company';
    final myAvatar = company?.logo ?? '';

    final otherAvatar = seeker.profilePic.isNotEmpty
        ? seeker.profilePic
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(seeker.name)}&background=random&color=fff&size=128';

    try {
      final chatID = await ChatService().getOrCreateChat(
        myID: companyID,
        myName: myName,
        myAvatar: myAvatar,
        otherID: seeker.jobSeekerID,
        otherName: seeker.name,
        otherAvatar: otherAvatar,
      );
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => ChatRoomScreen(
            chatID: chatID,
            otherUserName: seeker.name,
            otherUserAvatar: otherAvatar,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open chat. Try again.')),
      );
    }
  }

  Future<void> _confirmAndRemoveEmployee() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Remove Employee"),
        content: const Text(
          "This will end this employee's active status at your company. Continue?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await _removeEmployee();
  }

  Future<void> _removeEmployee() async {
    setState(() => _isRemoving = true);
    try {
      await _firebaseService.terminateEmployee(widget.employeeID);
      if (!mounted) return;
      // Pop with `true` so the dashboard knows to refresh its list.
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isRemoving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Couldn't remove employee: $e")));
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
                      title: "Employee Profile",
                      subTitle: seeker.name.isNotEmpty
                          ? seeker.name
                          : "Working Employee",
                      titleSize: 25,
                      subtitleSize: 15,
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
                      // Matches JobSeekerProfileScreen's own-profile padding
                      // (vertical: 30, horizontal: 20) instead of 40.
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "ABOUT ME",
                            fontSize: 20,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          const SizedBox(height: 10),

                          // ── Action row: Message + Remove Employee,
                          // same Row/Expanded layout as the job seeker's
                          // own "Requests" + "Update Profile" row.
                          Row(
                            children: [
                              Expanded(
                                child: TexxtButton(
                                  text: "Message",
                                  height: 44,
                                  textSize: 14,
                                  textColor: ElevateColor.gray,
                                  textWeight: FontWeight.w400,
                                  borderRadius: 50,
                                  backgroundColor: Colors.transparent,
                                  borderColor: ElevateColor.gray,
                                  borderWidth: 1,
                                  onTap: () => _onMessageTap(seeker),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _isRemoving
                                    ? const Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    : TexxtButton(
                                        text: "Remove Employee",
                                        height: 44,
                                        textSize: 14,
                                        textColor: Colors.red,
                                        textWeight: FontWeight.w400,
                                        borderRadius: 50,
                                        backgroundColor: Colors.transparent,
                                        borderColor: Colors.red,
                                        borderWidth: 1,
                                        onTap: _confirmAndRemoveEmployee,
                                      ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),
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
                                  const CustomText(
                                    text: "EXPERIENCE",
                                    fontSize: 20,
                                    color: ElevateColor.lightgray,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.left,
                                    lineHeight: 1.0,
                                  ),
                                  const SizedBox(height: 8),
                                  CustomText(
                                    text: seeker.experienceLevel.isNotEmpty
                                        ? seeker.experienceLevel
                                        : "No experience level added yet.",
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

                          // ── EARNED BADGES ─────────────────────────────
                          const SizedBox(height: 28),
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              const CustomText(
                                text: "EARNED BADGES",
                                fontSize: 20,
                                color: ElevateColor.lightgray,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.left,
                                lineHeight: 1.0,
                              ),
                              const Spacer(),
                              if (seeker.earnedBadges.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      36,
                                      87,
                                      87,
                                      87,
                                    ).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                        255,
                                        10,
                                        10,
                                        10,
                                      ).withValues(alpha: 0.4),
                                    ),
                                  ),
                                  child: Text(
                                    '${seeker.earnedBadges.length} badge${seeker.earnedBadges.length == 1 ? '' : 's'}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          if (_badgesLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(
                                  color: Color(0xFFFFD700),
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          else if (_earnedBadges.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.military_tech_outlined,
                                    size: 36,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No badges earned yet.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade500,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Column(
                              children: [
                                for (final badge in _earnedBadges) ...[
                                  Row(
                                    children: [
                                      Image.network(
                                        _getBadgeImageUrl(badge),
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF0F0F0),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.military_tech_outlined,
                                            size: 22,
                                            color: Colors.black26,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          badge.badgeName.isNotEmpty
                                              ? badge.badgeName
                                              : badge.badgeID,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF222222),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        badge.badgeLevel,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                ],
                              ],
                            ),

                          const SizedBox(height: 22),
                          if (seeker.education.isNotEmpty) ...[
                            const CustomText(
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
                                    // Matches job seeker's own profile:
                                    // "School — Year" instead of school-only.
                                    subText: "${edu.school} — ${edu.year}",
                                    iconData: Icons.school_outlined,
                                    iconSize: 25,
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 22),
                          ],

                          if (seeker.jobExperience.isNotEmpty) ...[
                            const CustomText(
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
                                    iconData: Icons.person_outline,
                                    startDate: work.from,
                                    endDate: work.to.isEmpty ? null : work.to,
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
                              Navigator.of(context, rootNavigator: true).push(
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
