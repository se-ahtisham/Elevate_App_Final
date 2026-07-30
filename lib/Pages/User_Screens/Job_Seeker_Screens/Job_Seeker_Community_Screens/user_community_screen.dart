import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Navigations/community_navigation.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Community_Screens/community_search.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Community_Screens/user_community_explore.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Community_Screens/user_community_myCommunity.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Community_Screens/user_community_myPost.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class UserCommunityScreen extends StatelessWidget {
  const UserCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: IconText(
                    text: "People Community",
                    iconData: Icons.people_alt_outlined,
                    textWeight: FontWeight.w600,
                    textSize: 20,
                    iconSize: 30,
                    iconTextSpacing: 10,
                  ),
                ),

                const SizedBox(width: 12),

                TextButtonGradient(
                  text: "Back",
                  width: 90,
                  height: 40,
                  textSize: 12,
                  textWeight: FontWeight.w500,
                  textColor: Colors.white,
                  borderColor: ElevateColor.gray,
                  borderRadius: 80,
                  borderWidth: 1,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 15),

            Expanded(
              child: CommunityNavigation(
                titles: const [
                  "Explore",
                  "Discover",
                  "My Communities",
                  "My Post",
                ],
                screens: const [
                  UserCommunityExploreScreen(),
                  CommunitySearch(),
                  UserCommunityMycommunityScreen(),
                  UserCommunityMypost(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
