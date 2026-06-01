import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/white_black_user.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Community_Screens/community_view_profile_screen.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Profile_Screens/job_Seeker_profile_screen.dart';
import 'package:flutter/material.dart';

class UserCommunityMycommunityScreen extends StatelessWidget {
  const UserCommunityMycommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSearchBar(
          hintText: "Search Followers",
          backgroundColor: const Color.fromARGB(255, 235, 235, 235),
          width: 380,
          height: 60,
          textSize: 15,
          iconSize: 30,
        ),
        SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                WhiteBlackUser(
                  imageURL:
                      "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                  name: "TechNova Lnc.",
                  shortDescription: "FinTech",
                  experience: "USA BASED",
                  firstContainerWidth: 270,
                  experienceBoxWidth: 240,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityViewProfileScreen(),
                      ),
                    );
                  },
                  tileHeight: 80,
                ),
                SizedBox(height: 10),
                WhiteBlackUser(
                  imageURL:
                      "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                  name: "TechNova Lnc.",
                  shortDescription: "FinTech",
                  experience: "USA BASED",
                  firstContainerWidth: 270,
                  experienceBoxWidth: 240,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityViewProfileScreen(),
                      ),
                    );
                  },
                  tileHeight: 80,
                ),
                SizedBox(height: 10),
                WhiteBlackUser(
                  imageURL:
                      "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                  name: "TechNova Lnc.",
                  shortDescription: "FinTech",
                  experience: "USA BASED",
                  firstContainerWidth: 270,
                  experienceBoxWidth: 240,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityViewProfileScreen(),
                      ),
                    );
                  },
                  tileHeight: 80,
                ),
                SizedBox(height: 10),
                WhiteBlackUser(
                  imageURL:
                      "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                  name: "TechNova Lnc.",
                  shortDescription: "FinTech",
                  experience: "USA BASED",
                  firstContainerWidth: 270,
                  experienceBoxWidth: 240,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityViewProfileScreen(),
                      ),
                    );
                  },
                  tileHeight: 80,
                ),
                SizedBox(height: 10),
               
              ],
            ),
          ),
        ),
      ],
    );
  }
}

