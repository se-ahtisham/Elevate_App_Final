import "package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart";
import "package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart";
import "package:elevate_app/Custom_Widgets/Header/elevate_header.dart";
import "package:elevate_app/Custom_Widgets/Text/custom_text.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_education.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_work.dart";
import "package:elevate_app/Data_Model_Classes/Firebase_Online_Models/badge_model.dart";
import "package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart";
import "package:elevate_app/Database/Online_Database/auth_service.dart";
import "package:elevate_app/Database/Online_Database/chat_service.dart";
import "package:elevate_app/Database/Online_Database/firebase_service.dart";
import "package:elevate_app/Pages/Shared_Screens/chat_room_screen.dart";
import "package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/company_portfolio_check.dart";
import "package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/company_view_user_post.dart";
import "package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class CompanyViewProfile extends StatefulWidget {
  final JobSeekerModel seeker;
  const CompanyViewProfile({super.key, required this.seeker});

  @override
  State<CompanyViewProfile> createState() => _CompanyViewProfileState();
}

class _CompanyViewProfileState extends State<CompanyViewProfile> {
  // ── Badges State ──────────────────────────────────────────────────────────
  bool _badgesLoading = true;
  List<BadgeModel> _earnedBadges = [];

  // ── Cloud Storage Fallback URLs for Badges (same as JobSeekerProfileScreen)
  static const String _bronzeCloudUrl =
      'https://firebasestorage.googleapis.com/v0/b/elevate-988ab.firebasestorage.app/o/badge_images%2Fbronze.png?alt=media&token=116cd0ca-d646-430a-8246-dfff9d29b673';
  static const String _silverCloudUrl =
      'https://firebasestorage.googleapis.com/v0/b/elevate-988ab.firebasestorage.app/o/badge_images%2Fsilver.png?alt=media&token=8ace9945-0206-4491-b175-db75e70b9ff7';
  static const String _goldCloudUrl =
      'https://firebasestorage.googleapis.com/v0/b/elevate-988ab.firebasestorage.app/o/badge_images%2Fgold.png?alt=media&token=8fa4f2b5-07f5-4b84-a943-02abb5989d72';

  @override
  void initState() {
    super.initState();
    _loadBadges();
  }

  Future<void> _loadBadges() async {
    final service = FirebaseService();
    final List<BadgeModel> badges = [];

    for (final badgeID in widget.seeker.earnedBadges) {
      final badge = await service.getBadgeById(badgeID);
      if (badge != null) badges.add(badge);
    }

    if (!mounted) return;
    setState(() {
      _earnedBadges = badges;
      _badgesLoading = false;
    });
  }

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
  Widget build(BuildContext context) {
    final seeker = widget.seeker;

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
                  title: "Your Digital Identity",
                  subTitle: "Account Control Center",
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 20,
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
                              onTap: () async {
                                final authService = AuthService();
                                final companyID =
                                    authService.currentUser?.uid ?? '';
                                final firebaseService = FirebaseService();
                                final company = await firebaseService
                                    .getCompany(companyID);
                                final companyName =
                                    company?.companyName ?? 'Company';
                                final companyAvatar =
                                    company?.logo.isNotEmpty == true
                                    ? company!.logo
                                    : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(companyName)}&background=random&color=fff&size=128';
                                final seekerAvatar =
                                    seeker.profilePic.isNotEmpty
                                    ? seeker.profilePic
                                    : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(seeker.name)}&background=random&color=fff&size=128';
                                try {
                                  final chatID = await ChatService()
                                      .getOrCreateChat(
                                        myID: companyID,
                                        myName: companyName,
                                        myAvatar: companyAvatar,
                                        otherID: seeker.jobSeekerID,
                                        otherName: seeker.name,
                                        otherAvatar: seekerAvatar,
                                      );
                                  if (!context.mounted) return;
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).push(
                                    MaterialPageRoute(
                                      builder: (_) => ChatRoomScreen(
                                        chatID: chatID,
                                        otherUserName: seeker.name,
                                        otherUserAvatar: seekerAvatar,
                                      ),
                                    ),
                                  );
                                } catch (_) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Could not open chat.'),
                                    ),
                                  );
                                }
                              },
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
                        city: seeker.location.isNotEmpty
                            ? seeker.location
                            : "No location added",
                        country: "",
                        email: seeker.email.isNotEmpty
                            ? seeker.email
                            : "No email added",
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

                      // ══════════════════════════════════════════════════
                      // EARNED BADGES SECTION — matches JobSeekerProfileScreen
                      // ══════════════════════════════════════════════════
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
                            border: Border.all(color: const Color(0xFFE0E0E0)),
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
                                        borderRadius: BorderRadius.circular(8),
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
                      const CustomText(
                        text: "EDUCATION",
                        fontSize: 20,
                        color: ElevateColor.lightgray,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        lineHeight: 1.0,
                      ),
                      const SizedBox(height: 15),
                      if (seeker.education.isEmpty)
                        const CustomText(
                          text: "No education added yet.",
                          fontSize: 13,
                          color: ElevateColor.whitegray,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.left,
                        )
                      else
                        Column(
                          children: [
                            for (final edu in seeker.education) ...[
                              UserEducation(
                                text: edu.title,
                                subText: "${edu.school} — ${edu.year}",
                                iconData: Icons.school_outlined,
                                iconSize: 25,
                              ),
                              const SizedBox(height: 15),
                            ],
                          ],
                        ),

                      const SizedBox(height: 22),
                      const CustomText(
                        text: "WORK",
                        fontSize: 20,
                        color: ElevateColor.lightgray,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        lineHeight: 1.0,
                      ),
                      const SizedBox(height: 15),
                      if (seeker.jobExperience.isEmpty)
                        const CustomText(
                          text: "No work experience added yet.",
                          fontSize: 13,
                          color: ElevateColor.whitegray,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.left,
                        )
                      else
                        Column(
                          children: [
                            for (final exp in seeker.jobExperience) ...[
                              UserWork(
                                title: exp.jobTitle,
                                subtitle: exp.company,
                                iconData: Icons.work_outline,
                                startDate: exp.from,
                                endDate: exp.to.isEmpty ? null : exp.to,
                              ),
                              const SizedBox(height: 15),
                            ],
                          ],
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
          ),
        ),
      ),
    );
  }
}
