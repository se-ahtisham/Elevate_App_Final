import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

/*StatelessWidget: UserSocialmedia
└── Column (crossAxisAlignment: start)
    ├── IconText (Location: "$city, $country")
    ├── SizedBox (height: 12)
    ├── IconText (Email: email)
    ├── SizedBox (height: 12)
    └── IconText (Phone: phone) */

class UserSocialmedia extends StatelessWidget {
  final String city;
  final String country;
  final String email;
  final String phone;
  final String web;

  const UserSocialmedia({
    super.key,
    required this.city,
    required this.country,
    required this.email,
    this.phone = "",
    this.web = "",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconText(
          text: "$city, $country",
          iconData: Icons.location_on,
          iconColor: ElevateColor.lightgray,
          iconSize: 18,
          iconTextSpacing: 8,
          textSize: 12,
          textColor: ElevateColor.lightgray,
          textWeight: FontWeight.w400,
          lineHeight: 1.2,
        ),
        SizedBox(height: 12),
        IconText(
          text: email,
          iconData: Icons.email_rounded,
          iconColor: ElevateColor.lightgray,
          iconSize: 18,
          iconTextSpacing: 8,
          textSize: 12,
          textColor: ElevateColor.lightgray,
          textWeight: FontWeight.w400,
          lineHeight: 1.2,
        ),
        if (phone.isNotEmpty) ...[
          const SizedBox(height: 12),
          IconText(
            text: phone,
            iconData: Icons.phone,
            iconColor: ElevateColor.lightgray,
            iconSize: 18,
            iconTextSpacing: 8,
            textSize: 12,
            textColor: ElevateColor.lightgray,
            textWeight: FontWeight.w400,
            lineHeight: 1.2,
          ),
        ],

        if (web.isNotEmpty) ...[
          const SizedBox(height: 12),
          IconText(
            text: web,
            iconData: Icons.language,
            iconColor: ElevateColor.lightgray,
            iconSize: 18,
            iconTextSpacing: 8,
            textSize: 12,
            textColor: ElevateColor.lightgray,
            textWeight: FontWeight.w400,
            lineHeight: 1.2,
          ),
        ],
      ],
    );
  }
}
