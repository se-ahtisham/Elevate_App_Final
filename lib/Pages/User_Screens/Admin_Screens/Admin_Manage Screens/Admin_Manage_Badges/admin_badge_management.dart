import 'package:elevate_app/Custom_Widgets/Tiles/manage_white_black_full.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Badges/admin_update_badge.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/badge_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
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
      allBadges = await firebaseService.listAllBadges();
      if (!mounted) return;
      setState(() {
        visibleBadges = allBadges;
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
                    const SizedBox(height: 25),

                    const IconText(
                      text: "Explore Badges",
                      iconData: Icons.workspace_premium_outlined,
                      textSize: 20,
                      textWeight: FontWeight.bold,
                      iconSize: 25,
                      iconTextSpacing: 10,
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
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ManageWhiteBlackFull(
                              titleText: badge.badgeName,
                              subtitleText:
                                  "Score: ${badge.minScore.toInt()}-${badge.maxScore.toInt()}",

                              tileHeight: 80,
                              titleFontSize: 20,
                              titleFontWeight: FontWeight.bold,
                              subtitleFontSize: 14,
                              subtitleFontWeight: FontWeight.normal,
                              subtitleColor: ElevateColor.gray,

                              firstContainerWidth: 280,
                              secondContainerWidth: 70,

                              sizedBetween: 3,

                              onTap: () => openUpdateScreen(badge),
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
