import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_black_tile.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/experience_white_black_full.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Posts_Screens/company_view_applied_candidate_profile_screen.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class ShowAppliedCandidatesScreen extends StatelessWidget {
  const ShowAppliedCandidatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JobBlackTile(
              title: "UI/UX Designer",
              company: "Microsoft",
              location: "USA",
              description:
                  "Strong skills in programming, debugging, and buildingrong skills in programming, debugging, and buildingrong skills in programming, debugging, and buildingrong skills in programming, debugging, and buildingrong skills in programming, debugging, and buildingrong skills in programming, debugging, and building efficient software solutions.",
              jobType: "Remote",
              jobMode: "Full Time",
              salary: "600/mon",
            ),
            SizedBox(height: 15),
            CustomSearchBar(
              hintText: "Search Candidates",
              backgroundColor: ElevateColor.white,
              width: 380,
              height: 60,
              textSize: 15,
              iconSize: 30,
            ),
            SizedBox(height: 15),
            IconText(
              text: "Applied Candidates",
              iconData: Icons.people_alt_outlined,
              textSize: 15,
              textWeight: FontWeight.bold,
              iconSize: 20,
              iconTextSpacing: 10,
            ),
            SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ExperienceWhiteBlackFull(
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
                      experience: "2-5 Experience",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CompanyViewAppliedCandidateProfileScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    ExperienceWhiteBlackFull(
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
                      experience: "2-5 Experience",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CompanyViewAppliedCandidateProfileScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    ExperienceWhiteBlackFull(
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
                      experience: "2-5 Experience",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CompanyViewAppliedCandidateProfileScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    ExperienceWhiteBlackFull(
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
                      experience: "2-5 Experience",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CompanyViewAppliedCandidateProfileScreen(),
                          ),
                        );
                      },
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
