import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

/*StatelessWidget: UserDescription
└── Row
    ├── Container (Profile Image)
    ├── SizedBox (width: 10)
    └── Expanded
        └── Column (crossAxisAlignment: start)
            ├── CustomText (name)
            ├── CustomText (shortDescription)
            ├── SizedBox (height: 10)
            └── Row (Stats)
                ├── Column (Skills)
                │   ├── CustomText (skills count)
                │   └── CustomText ("SKILLS")
                ├── SizedBox (width: 12)
                ├── Container (divider)
                ├── SizedBox (width: 12)
                ├── Column (Followers)
                │   ├── CustomText (followers count)
                │   └── CustomText ("Followers")
                ├── SizedBox (width: 12)
                ├── Container (divider)
                ├── SizedBox (width: 12)
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
  final bool showSkills;

  const UserDescription({
    super.key,
    required this.imageURL,
    required this.name,
    this.shortDescription = "",
    this.skills = 0,
    this.followings = 0,
    this.followers = 0,
    this.showSkills = true,
  });

  ImageProvider? _getImageProvider(String path) {
    if (path.isEmpty) return null;
    if (path.startsWith("http://") || path.startsWith("https://")) {
      return NetworkImage(path);
    }
    return AssetImage(path);
  }

  @override
  Widget build(BuildContext context) {
    final provider = _getImageProvider(imageURL);

    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ElevateColor.lightgray,
              image: provider != null
                  ? DecorationImage(image: provider, fit: BoxFit.cover)
                  : null,
            ),
            child: provider == null
                ? const Center(
                    child: Icon(Icons.person, size: 55, color: Colors.white),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          // ── Wrapped in Expanded so this column is constrained to the
          // remaining row width instead of sizing to its own content —
          // this is what was causing the RenderFlex overflow.
          Expanded(
            child: Column(
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
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                Row(
                  // Prevents this inner stats row from trying to grow beyond
                  // what its children need, while still fitting inside the
                  // Expanded parent instead of overflowing it.
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showSkills) ...[
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
                          const CustomText(text: "SKILLS", fontSize: 10),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Container(width: 1, height: 35, color: ElevateColor.gray),
                      const SizedBox(width: 12),
                    ],
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
                        const CustomText(text: "Followers", fontSize: 10),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Container(width: 1, height: 35, color: ElevateColor.gray),
                    const SizedBox(width: 12),
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
                        const CustomText(text: "Following", fontSize: 10),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
