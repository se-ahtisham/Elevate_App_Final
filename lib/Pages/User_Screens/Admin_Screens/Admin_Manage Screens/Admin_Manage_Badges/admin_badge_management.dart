import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/admin_badge_create_card.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/admin_badge_result_card.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Badges/admin_update_badge.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/admin_manage.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminBadgeManagement extends StatefulWidget {
  const AdminBadgeManagement({super.key});

  @override
  State<AdminBadgeManagement> createState() => _AdminBadgeManagementState();
}

class _AdminBadgeManagementState extends State<AdminBadgeManagement> {
  final TextEditingController searchController =
      TextEditingController(text: "10110");

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 40;

    return Scaffold(
      backgroundColor: ElevateColor.white,
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final headerHeight = constraints.maxHeight.clamp(150.0, 205.0);
                  return Stack(
                    children: [
                      ElevateHeader(
                        title: "Elevate",
                        subTitle: "Badges",
                        titleSize: 35,
                        subtitleSize: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 250.0, top: 170),
                        child: TextButtonGradient(
                          text: "Dashboard",
                          height: 50,
                          width: 150,
                          borderRadius: 25,
                          buttonBackgroundColor: ElevateGradientColors.white,
                          textColor: Colors.black,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminManage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                color: const Color(0xFFF4F4F4),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 90),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdminBadgeCreateCard(
                        code: "110011",
                        onCreate: () {},
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Icon(
                            Icons.emoji_events_outlined,
                            size: 16,
                            color: ElevateColor.gray,
                          ),
                          const SizedBox(width: 8),
                          CustomText(
                            text: "Explore Badge",
                            fontSize: 12,
                            color: ElevateColor.gray,
                            fontWeight: FontWeight.w600,
                            lineHeight: 1.0,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomSearchBar(
                        hintText: "",
                        controller: searchController,
                        iconData: Icons.search_rounded,
                        iconSize: 18,
                        iconColor: ElevateColor.gray,
                        iconTextSpacing: 8,
                        backgroundColor: ElevateColor.white,
                        borderRadius: 28,
                        height: 34,
                        width: width,
                        textSize: 12,
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      AdminBadgeResultCard(
                        badgeCode: "10110",
                        badgeImagePath:
                            'lib/Resources/Images/Coding_Badges/Pure/pure_medium.png',
                        onManage:  () {
Navigator.push( context, MaterialPageRoute( builder: (context) => AdminUpdateBadge(), ),);
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