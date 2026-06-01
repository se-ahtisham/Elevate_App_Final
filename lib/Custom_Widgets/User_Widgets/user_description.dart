import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

/*StatelessWidget: UserDescription
└── Row
    ├── Container (Profile Image)
    ├── SizedBox (width: 10)
    └── Column (crossAxisAlignment: start)
        ├── CustomText (name)
        ├── CustomText (shortDescription)
        ├── SizedBox (height: 10)
        └── Row (Stats)
            ├── Column (Skills)
            │   ├── CustomText (skills count)
            │   └── CustomText ("SKILLS")
            ├── SizedBox (width: 20)
            ├── Container (divider)
            ├── SizedBox (width: 20)
            ├── Column (Followers)
            │   ├── CustomText (followers count)
            │   └── CustomText ("Followers")
            ├── SizedBox (width: 20)
            ├── Container (divider)
            ├── SizedBox (width: 20)
            └── Column (Following)
                ├── CustomText (followings count)
                └── CustomText ("Following") */



class UserDescription extends StatelessWidget {
  final String imageURL;
  final String name;
  final String shortDescription;
  final int skills;
  final int followings;
  final int followers;

  const UserDescription({
    super.key,
    required this.imageURL,
    required this.name,
    this.shortDescription = "",
    this.skills = 0,
    this.followings = 0,
    this.followers = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(imageURL),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name tag
              CustomText(
                text: name,
                fontSize: 16,
                color: ElevateColor.lightgray,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.left,
                lineHeight: 1.0,
              ),
              CustomText(
                text: shortDescription,
                fontSize: 11,
                color: ElevateColor.black,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  // Skill Column
                  Column(
                    children: [
                      CustomText(
                        text: skills.toString(),
                        fontSize: 15,
                        lineHeight: 1,
                        fontWeight: FontWeight.w600,
                        color: ElevateColor.gray,
                      ),
                      CustomText(text: "SKILLS", fontSize: 10),
                    ],
                  ),
                  SizedBox(width: 20),
                  Container(width: 1, height: 35, color: ElevateColor.gray),
                  SizedBox(width: 20),
                  // Followers Column
                  Column(
                    children: [
                      CustomText(
                        text: followers.toString(),
                        fontSize: 15,
                        lineHeight: 1,
                        fontWeight: FontWeight.w600,
                        color: ElevateColor.gray,
                      ),
                      CustomText(text: "Followers", fontSize: 10),
                    ],
                  ),
                  SizedBox(width: 20),
                  Container(width: 1, height: 35, color: ElevateColor.gray),
                  SizedBox(width: 20),
                  // Following Column
                  Column(
                    children: [
                      CustomText(
                        text: followings.toString(),
                        fontSize: 15,
                        lineHeight: 1,
                        fontWeight: FontWeight.w600,
                        color: ElevateColor.gray,
                      ),
                      CustomText(text: "Following", fontSize: 10),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
