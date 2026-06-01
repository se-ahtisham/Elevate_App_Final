import 'package:elevate_app/Custom_Widgets/Buttons/icon_text_button.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/admin_post_tile.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Community/admin_comment_management.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/admin_manage.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class AdminCommunityManagement extends StatelessWidget {
  const AdminCommunityManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconTextButton(
                  text: "Communities",
                  iconData: Icons.people,
                  backgroundColor: Colors.transparent,
                  iconColor: ElevateColor.gray,
                  textColor: ElevateColor.gray,
                  textSize: 15,
                  iconSize: 30,
                  textWeight: FontWeight.w600,
                ),
                SizedBox(width: 60),
                Expanded(
                  child: TextButtonGradient(
                    text: "Dashboard",
                    height: 45,
                    borderRadius: 25,
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
            ),
            SizedBox(height: 30),
            CustomSearchBar(
              hintText: "Ahtisham",
              backgroundColor: ElevateColor.white,
              width: 380,
              height: 60,
              textSize: 15,
              iconSize: 30,
            ),
            SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AdminPostTile(
                      title: "This is what i learned in my recent course",
                      text:
                          "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life. Finding harmony in the ebb and flow of experiences, we unlock the profound beauty that resides within our shared journey.",
                      commentCount: 3,
                      comments: ["Good", "Nice", "Awesome"],
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
                      deleteonTap: () {
                        Navigator.pop(context);
                      },
                      viewCommentonTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminCommentManagement(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 25),
                    AdminPostTile(
                      title: "This is what i learned in my recent course",
                      text:
                          "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life. Finding harmony in the ebb and flow of experiences, we unlock the profound beauty that resides within our shared journey.",
                      commentCount: 3,
                      comments: ["Good", "Nice", "Awesome"],
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
                      deleteonTap: () {
                        Navigator.pop(context);
                      },
                      viewCommentonTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminCommentManagement(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 25),
                    AdminPostTile(
                      title: "This is what i learned in my recent course",
                      text:
                          "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life. Finding harmony in the ebb and flow of experiences, we unlock the profound beauty that resides within our shared journey.",
                      commentCount: 3,
                      comments: ["Good", "Nice", "Awesome"],
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
                      deleteonTap: () {
                        Navigator.pop(context);
                      },
                      viewCommentonTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminCommentManagement(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 25),
                    AdminPostTile(
                      title: "This is what i learned in my recent course",
                      text:
                          "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life. Finding harmony in the ebb and flow of experiences, we unlock the profound beauty that resides within our shared journey.",
                      commentCount: 3,
                      comments: ["Good", "Nice", "Awesome"],
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
                      deleteonTap: () {
                        Navigator.pop(context);
                      },
                      viewCommentonTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminCommentManagement(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 25),
                    AdminPostTile(
                      title: "This is what i learned in my recent course",
                      text:
                          "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life. Finding harmony in the ebb and flow of experiences, we unlock the profound beauty that resides within our shared journey.",
                      commentCount: 3,
                      comments: ["Good", "Nice", "Awesome"],
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
                      deleteonTap: () {
                        Navigator.pop(context);
                      },
                      viewCommentonTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminCommentManagement(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 25),
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
