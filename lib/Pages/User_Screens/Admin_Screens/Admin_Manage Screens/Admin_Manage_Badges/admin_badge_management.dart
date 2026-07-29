import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Badges/admin_update_badge.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/badge_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:elevate_app/constants/badge_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminBadgesManagement extends StatefulWidget {
  const AdminBadgesManagement({super.key});

  @override
  State<AdminBadgesManagement> createState() => _AdminBadgesManagementState();
}

class _AdminBadgesManagementState extends State<AdminBadgesManagement> {
  final FirebaseService firebaseService = FirebaseService();
  final searchController = TextEditingController();

  List<BadgeModel> allBadges = [];
  List<BadgeModel> visibleBadges = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAllBadges();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadAllBadges() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final fetched = await firebaseService.listAllBadges();

      // Deduplicate fetched badges by badgeName (Bronze, Silver, Gold)
      final Map<String, BadgeModel> badgeMap = {};

      for (var b in fetched) {
        badgeMap[b.badgeName.toLowerCase().trim()] = b;
      }

      // Ensure default 3 badges exist
      final defaultBadges = [
        BadgeModel(
          badgeID: 'bronze_badge',
          badgeName: 'Bronze',
          badgeLevel: 'Bronze',
          minScore: 50,
          maxScore: 60,
          badgeImage: BadgeConstants.bronzeUrl,
        ),
        BadgeModel(
          badgeID: 'silver_badge',
          badgeName: 'Silver',
          badgeLevel: 'Silver',
          minScore: 60,
          maxScore: 90,
          badgeImage: BadgeConstants.silverUrl,
        ),
        BadgeModel(
          badgeID: 'gold_badge',
          badgeName: 'Gold',
          badgeLevel: 'Gold',
          minScore: 90,
          maxScore: 100,
          badgeImage: BadgeConstants.goldUrl,
        ),
      ];

      for (var def in defaultBadges) {
        final key = def.badgeName.toLowerCase();
        if (!badgeMap.containsKey(key)) {
          badgeMap[key] = def;
          // Seed to firestore if missing
          try {
            await firebaseService.createNewBadge(def);
          } catch (_) {}
        }
      }

      final list = badgeMap.values.toList();
      // Sort in standard order: Bronze, Silver, Gold
      final order = {'bronze': 1, 'silver': 2, 'gold': 3};
      list.sort((a, b) {
        final oa = order[a.badgeName.toLowerCase()] ?? 99;
        final ob = order[b.badgeName.toLowerCase()] ?? 99;
        return oa.compareTo(ob);
      });

      if (!mounted) return;
      setState(() {
        allBadges = list;
        visibleBadges = list;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't load badges. Try again.")),
      );
    }
  }

  void onSearchChanged(String query) {
    query = query.toLowerCase();
    setState(() {
      visibleBadges = allBadges.where((badge) {
        return badge.badgeName.toLowerCase().contains(query);
      }).toList();
    });
  }

  void openUpdateScreen(BadgeModel badge) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdminUpdateBadge(badge: badge)),
    );

    if (updated == true) {
      loadAllBadges();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF3F3F3),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            const ElevateHeader(
              title: "Elevate",
              subTitle: "Badges",
              titleSize: 40,
              subtitleSize: 25,
              showBackButton: true,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const IconText(
                      text: "Manage App Badges",
                      iconData: Icons.workspace_premium_outlined,
                      textSize: 20,
                      textWeight: FontWeight.bold,
                      iconSize: 25,
                      iconTextSpacing: 10,
                    ),
                    const SizedBox(height: 5),
                    const CustomText(
                      text: "Only Bronze, Silver, and Gold badges are supported.",
                      fontSize: 13,
                      color: ElevateColor.gray,
                    ),

                    const SizedBox(height: 15),

                    CustomSearchBar(
                      hintText: "Search Badge",
                      backgroundColor: ElevateColor.white,
                      width: 380,
                      height: 60,
                      textSize: 15,
                      iconSize: 30,
                      controller: searchController,
                      onChanged: onSearchChanged,
                    ),

                    const SizedBox(height: 20),

                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                      )
                    else if (visibleBadges.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: CustomText(
                            text: "No badges found.",
                            fontSize: 15,
                            color: ElevateColor.gray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      Column(
                        children: visibleBadges.map((badge) {
                          final imgUrl = badge.badgeImage.isNotEmpty
                              ? (badge.badgeImage.startsWith('http')
                                  ? badge.badgeImage
                                  : BadgeConstants.getBadgeUrl(badge.badgeName))
                              : BadgeConstants.getBadgeUrl(badge.badgeName);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.grey.shade100,
                                    backgroundImage: NetworkImage(imgUrl),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: "${badge.badgeName} Badge",
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        const SizedBox(height: 4),
                                        CustomText(
                                          text:
                                              "Required Score: ${badge.minScore.toInt()}-${badge.maxScore.toInt()}",
                                          fontSize: 13,
                                          color: ElevateColor.gray,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ),
                                    onPressed: () => openUpdateScreen(badge),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
