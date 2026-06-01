import 'package:elevate_app/Custom_Widgets/Buttons/icon_text_button.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/admin_comment_tile.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/user_Comment_tile.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class UserCommentsScreen extends StatelessWidget {
  const UserCommentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              textSize: 18,
              iconSize: 30,
              textWeight: FontWeight.w600,
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
                    SizedBox(height: 15),
                    UserCommentTile(
                      title: "This is what i learned in my recent course",
                      text:
                          "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life. Finding harmony in the ebb and flow of experiences, we unlock the profound beauty that resides within our shared journey.",
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
                    ),
                    SizedBox(height: 15),
                    UserCommentTile(
                      title: "This is what i learned in my recent course",
                      text:
                          "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life. Finding harmony in the ebb and flow of experiences, we unlock the profound beauty that resides within our shared journey.",
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
                    ),
                    SizedBox(height: 15),
                    UserCommentTile(
                      title: "This is what i learned in my recent course",
                      text:
                          "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life. Finding harmony in the ebb and flow of experiences, we unlock the profound beauty that resides within our shared journey.",
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
                    ),
                    SizedBox(height: 15),
                    UserCommentTile(
                      title: "This is what i learned in my recent course",
                      text:
                          "The whole secret of existence lies in the pursuit of meaning, purpose, and connection. It is a delicate dance between self-discovery, compassion for others, and embracing the ever-unfolding mysteries of life. Finding harmony in the ebb and flow of experiences, we unlock the profound beauty that resides within our shared journey.",
                      imageURL:
                          "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                      name: "Muhaamad Ahtisham",
                      shortDescription: "Flutter Developer",
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
