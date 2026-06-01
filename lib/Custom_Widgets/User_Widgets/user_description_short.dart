import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

/*StatelessWidget: UserDescriptionShort
└── Row
    ├── Container (Profile Image)
    ├── SizedBox (width: 10)
    └── Column (crossAxisAlignment: start)
        ├── CustomText (name)
        ├── CustomText (shortDescription)*/

class UserDescriptionShort extends StatelessWidget {
  final String imageURL;
  final String name;
  final String shortDescription;

  const UserDescriptionShort({
    super.key,
    required this.imageURL,
    required this.name,
    this.shortDescription = "",
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(imageURL),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: name,
                fontSize: 14,
                color: ElevateColor.lightgray,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.left,
                lineHeight: 1,
              ),
              CustomText(
                text: shortDescription,
                fontSize: 11,
                color: ElevateColor.black,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
