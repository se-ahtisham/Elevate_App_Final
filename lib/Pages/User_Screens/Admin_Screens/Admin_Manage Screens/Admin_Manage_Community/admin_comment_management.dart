import 'package:elevate_app/Custom_Widgets/Buttons/icon_text_button.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/admin_comment_tile.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Community/admin_community_management.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class AdminCommentManagement extends StatelessWidget {
  const AdminCommentManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconTextButton(
                  text: "People Comment’s",
                  iconData: Icons.people_alt_outlined,
                  backgroundColor: Colors.transparent,
                  iconColor: ElevateColor.gray,
                  textColor: ElevateColor.gray,
                  textSize: 15,
                  iconSize: 30,
                  textWeight: FontWeight.w600,
                ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AdminCommentTile(
                      title: "This is what i learned in my recent course",
                      text: "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life. Finding harmony in the ebb and flow of experiences, we unlock the profound beauty that resides within our shared journey.",
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
                       onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminCommunityManagement(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                       AdminCommentTile(
                      title: "This is what i learned in my recent course",
                      text: "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life. Finding harmony in the ebb and flow of experiences, we unlock the profound beauty that resides within our shared journey.",
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
                       onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminCommunityManagement(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),  AdminCommentTile(
                      title: "This is what i learned in my recent course",
                      text: "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life. Finding harmony in the ebb and flow of experiences, we unlock the profound beauty that resides within our shared journey.",
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
                       onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminCommunityManagement(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),  AdminCommentTile(
                      title: "This is what i learned in my recent course",
                      text: "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life. Finding harmony in the ebb and flow of experiences, we unlock the profound beauty that resides within our shared journey.",
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
                       onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminCommunityManagement(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),  AdminCommentTile(
                      title: "This is what i learned in my recent course",
                      text: "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life. Finding harmony in the ebb and flow of experiences, we unlock the profound beauty that resides within our shared journey.",
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
                       onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminCommunityManagement(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    
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
