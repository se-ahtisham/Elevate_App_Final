import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/short_description_round_circle_icon_tile.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/user_check_company_profile.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class UserSearchCompany extends StatelessWidget {
  const UserSearchCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconText(
                text: "Explore Companies",
                iconData: Icons.people_alt_outlined,
                textWeight: FontWeight.w600,
                iconSize: 25,
                textSize: 17,
              ),
              SizedBox(height: 25),
              CustomSearchBar(
                hintText: "TechNova Inc.",
                backgroundColor: ElevateColor.white,
                width: 330,
                height: 50,
                textSize: 15,
              ),
              SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ShortDescriptionRoundCircleIconTile(
                        height: 80,
                        width: 330,
                        backgroundColor: ElevateColor.white,
                        borderRadius: 20,
                        imageURL:
                            'lib/Resources/Images/Profile_Images/Company_Logo.jpg',
                        name: 'TechNova Inc.',
                        shortDescription: 'FinTech',
                        iconData: Icons.arrow_forward,
                        iconSize: 24,
                        iconColor: Colors.white,
                        circleSize: 50,
                        circleColor: ElevateColor.lightgray,
                        borderWidth: 2,
                        borderColor: ElevateColor.lightgray,

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserCheckCompanyProfile(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 5),

ShortDescriptionRoundCircleIconTile(
                        height: 80,
                        width: 330,
                        backgroundColor: ElevateColor.white,
                        borderRadius: 20,
                        imageURL:
                            'lib/Resources/Images/Profile_Images/Company_Logo.jpg',
                        name: 'TechNova Inc.',
                        shortDescription: 'FinTech',
                        iconData: Icons.arrow_forward,
                        iconSize: 24,
                        iconColor: Colors.white,
                        circleSize: 50,
                        circleColor: ElevateColor.lightgray,
                        borderWidth: 2,
                        borderColor: ElevateColor.lightgray,

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserCheckCompanyProfile(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 5),ShortDescriptionRoundCircleIconTile(
                        height: 80,
                        width: 330,
                        backgroundColor: ElevateColor.white,
                        borderRadius: 20,
                        imageURL:
                            'lib/Resources/Images/Profile_Images/Company_Logo.jpg',
                        name: 'TechNova Inc.',
                        shortDescription: 'FinTech',
                        iconData: Icons.arrow_forward,
                        iconSize: 24,
                        iconColor: Colors.white,
                        circleSize: 50,
                        circleColor: ElevateColor.lightgray,
                        borderWidth: 2,
                        borderColor: ElevateColor.lightgray,

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserCheckCompanyProfile(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 5),ShortDescriptionRoundCircleIconTile(
                        height: 80,
                        width: 330,
                        backgroundColor: ElevateColor.white,
                        borderRadius: 20,
                        imageURL:
                            'lib/Resources/Images/Profile_Images/Company_Logo.jpg',
                        name: 'TechNova Inc.',
                        shortDescription: 'FinTech',
                        iconData: Icons.arrow_forward,
                        iconSize: 24,
                        iconColor: Colors.white,
                        circleSize: 50,
                        circleColor: ElevateColor.lightgray,
                        borderWidth: 2,
                        borderColor: ElevateColor.lightgray,

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserCheckCompanyProfile(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 5),





                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
