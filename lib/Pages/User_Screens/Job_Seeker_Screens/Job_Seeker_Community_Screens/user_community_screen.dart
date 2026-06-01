import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Navigations/community_navigation.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Community_Screens/user_community_explore_screen.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Community_Screens/user_community_myCommunity_screen.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Community_Screens/user_community_myPost_screen.dart';
import 'package:flutter/material.dart';

class UserCommunityScreen extends StatefulWidget {
  const UserCommunityScreen({super.key});

  @override
  State<UserCommunityScreen> createState() => _UserCommunityScreenState();
}

class _UserCommunityScreenState extends State<UserCommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
        child: Column(
          children: [
            const IconText(
              text: "People Comment's",
              iconData: Icons.people_alt_outlined,
              textWeight: FontWeight.w600,
              textSize: 20,
              iconSize: 30,
              iconTextSpacing: 10,
            ),

            const SizedBox(height: 15),

            Expanded(
              child: CommunityNavigation(
                titles: const ["Explore", "My Communities", "My Post"],
                screens: const [
                  UserCommunityExploreScreen(),
                  UserCommunityMycommunityScreen(),
                  UserCommunityMypostScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
