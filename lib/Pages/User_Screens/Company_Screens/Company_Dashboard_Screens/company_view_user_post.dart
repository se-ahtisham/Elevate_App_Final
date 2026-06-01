import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/user_Comment_tile.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_comments.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class CompanyViewUserPost extends StatefulWidget {
  const CompanyViewUserPost({super.key});

  @override
  State<CompanyViewUserPost> createState() => _CompanyViewUserProfileState();
}

class _CompanyViewUserProfileState extends State<CompanyViewUserPost> {
  final TextEditingController searchPostController = TextEditingController();

  @override
  void dispose() {
    searchPostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElevateColor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconText(
              text: "Candidate Post's",
              iconData: Icons.people_alt_outlined,
              textWeight: FontWeight.w600,
              textSize: 17,
            ),
            SizedBox(height: 30),
            CustomSearchBar(
              hintText: "Explore Posts",
              iconData: Icons.search,
              iconColor: const Color(0xFF1C1C3A),
              controller: searchPostController,
              width: 350,
              height: 50,
              textSize: 15,
              backgroundColor: const Color.fromARGB(255, 241, 241, 241),
              onTap: () {},
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    UserCommentTile(
                      title: "This is what i learned in my recent course",
                      text:
                          "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life. Finding harmony in the ebb and flow of experiences, we unlock the profound beauty that resides within our shared journey.",
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
                    ),
                    UserCommentTile(
                      title: "This is what i learned in my recent course",
                      text:
                          "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life. Finding harmony in the ebb and flow of experiences, we unlock the profound beauty that resides within our shared journey.",
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
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
