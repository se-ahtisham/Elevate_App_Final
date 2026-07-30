import "package:elevate_app/Animation/slide_left_route.dart";
import "package:elevate_app/Custom_Widgets/Buttons/icon_text_button.dart";
import "package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart";
import "package:elevate_app/Custom_Widgets/Text/custom_text.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_education.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_work.dart";
import "package:elevate_app/Data_Model_Classes/Firebase_Online_Models/badge_model.dart";
import "package:elevate_app/Database/Online_Database/auth_provider.dart";
import "package:elevate_app/Database/Online_Database/firebase_service.dart";
import "package:elevate_app/Pages/Login_Screens/Login_Screen.dart";
import "package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Profile_Screens/job_seeker_follow_requests.dart";
import "package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Profile_Screens/job_seeker_update_profile.dart";
import "package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Profile_Screens/job_seeker_working_companies.dart";
import "package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:elevate_app/Custom_Widgets/Header/elevate_header.dart";

class JobSeekerProfileScreen extends ConsumerStatefulWidget {
  const JobSeekerProfileScreen({super.key});

  @override
  ConsumerState<JobSeekerProfileScreen> createState() =>
      _JobSeekerProfileScreenState();
}

class _JobSeekerProfileScreenState
    extends ConsumerState<JobSeekerProfileScreen> {
  bool isLoading = true;

  // ── Badges State ──────────────────────────────────────────────────────────
  bool _badgesLoading = false;
  List<BadgeModel> _earnedBadges = [];

  // ── Cloud Storage Fallback URLs for Badges ────────────────────────────────
  static const String _bronzeCloudUrl =
      'https://firebasestorage.googleapis.com/v0/b/elevate-988ab.firebasestorage.app/o/badge_images%2Fbronze.png?alt=media&token=116cd0ca-d646-430a-8246-dfff9d29b673';
  static const String _silverCloudUrl =
      'https://firebasestorage.googleapis.com/v0/b/elevate-988ab.firebasestorage.app/o/badge_images%2Fsilver.png?alt=media&token=8ace9945-0206-4491-b175-db75e70b9ff7';
  static const String _goldCloudUrl =
      'https://firebasestorage.googleapis.com/v0/b/elevate-988ab.firebasestorage.app/o/badge_images%2Fgold.png?alt=media&token=8fa4f2b5-07f5-4b84-a943-02abb5989d72';

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    await ref.read(authProvider.notifier).loadCurrentUser();
    if (!mounted) return;
    setState(() => isLoading = false);
    await _loadBadges();
  }

  // ── Fetch earned badges from Firebase ─────────────────────────────────────
  Future<void> _loadBadges() async {
    final jobSeeker = ref.read(authProvider).jobSeeker;
    if (jobSeeker == null) return;

    setState(() => _badgesLoading = true);

    final service = FirebaseService();
    final List<BadgeModel> badges = [];

    for (final badgeID in jobSeeker.earnedBadges) {
      final badge = await service.getBadgeById(badgeID);
      if (badge != null) badges.add(badge);
    }

    if (!mounted) return;
    setState(() {
      _earnedBadges = badges;
      _badgesLoading = false;
    });
  }

  void _handleLogout() async {
    await ref.read(authProvider.notifier).logout();
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  // ── Cloud Image URL helper ────────────────────────────────────────────────
  // Only 3 badge images exist in Firebase Storage: Gold, Silver, Bronze.
  // Every badge uses its level's fixed cloud image + the skill name as the
  // text label — the image is intentionally shared across badges of the
  // same level, so we always resolve by level (not by a per-badge field).
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
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

    final jobSeeker = ref.watch(authProvider).jobSeeker;

    if (jobSeeker == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("No profile data found.")),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevateHeader(
                title: "Your Digital Identity",
                subTitle: "Account Control Center",
                titleSize: 25,
                subtitleSize: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 20),
                child: UserDescription(
                  imageURL: jobSeeker.profilePic.isNotEmpty
                      ? jobSeeker.profilePic
                      : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(jobSeeker.name.isNotEmpty ? jobSeeker.name : "User")}&background=random&color=fff&size=128',
                  name: jobSeeker.name,
                  shortDescription: jobSeeker.about.isNotEmpty
                      ? jobSeeker.about
                      : "No bio added yet.",
                  skills: jobSeeker.skillCount,
                  followers: jobSeeker.followers.length,
                  followings: jobSeeker.following.length,
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
                    const CustomText(
                      text: "ABOUT ME",
                      fontSize: 20,
                      color: ElevateColor.lightgray,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.left,
                      lineHeight: 1.0,
                    ),
                    const SizedBox(height: 10),

                    // ── Row 1: Requests + Update Profile ──────────
                    Row(
                      children: [
                        IconTextButton(
                          text: "Requests",
                          iconData: Icons.person_add_alt_1_outlined,
                          backgroundColor: ElevateColor.white,
                          iconColor: ElevateColor.lightgray,
                          textColor: ElevateColor.gray,
                          textWeight: FontWeight.bold,
                          borderColor: ElevateColor.gray,
                          borderRadius: 50,
                          textSize: 12,
                          height: 40,
                          width: 120,
                          onTap: () async {
                            await Navigator.of(
                              context,
                              rootNavigator: true,
                            ).push(
                              SlideLeftRoute(
                                page: const JobSeekerFollowRequests(),
                              ),
                            );
                            loadUser();
                          },
                        ),
                        const SizedBox(width: 10),
                        IconTextButton(
                          text: "Update Profile",
                          iconData: Icons.settings,
                          backgroundColor: ElevateColor.white,
                          iconColor: ElevateColor.lightgray,
                          textColor: ElevateColor.gray,
                          textWeight: FontWeight.bold,
                          borderColor: ElevateColor.gray,
                          borderRadius: 50,
                          textSize: 12,
                          height: 40,
                          width: 140,
                          onTap: () async {
                            await Navigator.of(
                              context,
                              rootNavigator: true,
                            ).push(
                              SlideLeftRoute(
                                page: const JobSeekerUpdateProfile(),
                              ),
                            );
                            loadUser();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ── Row 2: Working Companies (full width below) ─
                    IconTextButton(
                      text: "Working Companies",
                      iconData: Icons.business_center_outlined,
                      backgroundColor: ElevateColor.white,
                      iconColor: ElevateColor.lightgray,
                      textColor: ElevateColor.gray,
                      textWeight: FontWeight.bold,
                      borderColor: ElevateColor.gray,
                      borderRadius: 50,
                      textSize: 12,
                      height: 40,
                      width: double.infinity,
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          SlideLeftRoute(
                            page: JobSeekerWorkingCompanies(
                              jobSeekerID: jobSeeker.jobSeekerID,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),
                    CustomText(
                      text: jobSeeker.about.isNotEmpty
                          ? jobSeeker.about
                          : "No description added yet.",
                      fontSize: 13,
                      color: ElevateColor.whitegray,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.justify,
                      lineHeight: 1.3,
                    ),
                    const SizedBox(height: 22),
                    UserSocialmedia(
                      city: jobSeeker.location.isNotEmpty
                          ? jobSeeker.location
                          : "No location added",
                      country: "",
                      email: jobSeeker.email.isNotEmpty
                          ? jobSeeker.email
                          : "No email added",
                      phone: "Not provided",
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
                              text: jobSeeker.experienceLevel.isNotEmpty
                                  ? jobSeeker.experienceLevel
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

                    // ══════════════════════════════════════════════════════════
                    // EARNED BADGES SECTION — simple vertical list
                    // ══════════════════════════════════════════════════════════
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
                        if (jobSeeker.earnedBadges.isNotEmpty)
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
                              '${jobSeeker.earnedBadges.length} badge${jobSeeker.earnedBadges.length == 1 ? '' : 's'}',
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
                              'No badges earned yet.\nPass a skill test to earn your first badge!',
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
                      // Simple vertical list — badge image, 10px gap, skill
                      // name. No card/border/shadow styling. If the image
                      // fails to load on web (CORS etc.), it just leaves an
                      // empty space instead of an error/placeholder icon.
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
                    if (jobSeeker.education.isEmpty)
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
                          for (final edu in jobSeeker.education) ...[
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
                    if (jobSeeker.jobExperience.isEmpty)
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
                          for (final exp in jobSeeker.jobExperience) ...[
                            UserWork(
                              title: exp.jobTitle,
                              subtitle: exp.company,
                              iconData: Icons.person_outline,
                              startDate: exp.from,
                              endDate: exp.to.isEmpty ? null : exp.to,
                            ),
                            const SizedBox(height: 15),
                          ],
                        ],
                      ),

                    const SizedBox(height: 40),

                    TexxtButton(
                      text: "Log Out",
                      textSize: 13,
                      textColor: Colors.black,
                      textWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                      backgroundColor: Colors.white,
                      borderColor: Colors.black,
                      borderRadius: 30,
                      borderWidth: 1,
                      height: 50,
                      onTap: _handleLogout,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
