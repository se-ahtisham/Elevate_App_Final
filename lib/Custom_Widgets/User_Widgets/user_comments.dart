import 'package:elevate_app/Custom_Widgets/Buttons/icon_text_button.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description_short.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

/*StatelessWidget: UserComments
└── Container (width: 350)
    └── Padding
        └── SingleChildScrollView
            └── Column (crossAxisAlignment: start)
                ├── Row
                │   ├── Expanded
                │   │   └── UserDescriptionShort (imageURL, name, shortDescription)
                │   └── IconTextButton ("Follow")
                ├── SizedBox (height: 15)
                └── CustomText (commentText)*/


// Why scrollable view used in this: I text will be large then height contant will show error


class UserComments extends StatelessWidget {
  final String userName;
  final String usershortDescription;
  final String image;
  final String commentText;

  final double textSize;
  final Color textColor;
  final FontWeight textWeight;
  final double lineHeight;
  final TextAlign textAlign;
  final int? maxLines;

  const UserComments({
    super.key,
    required this.userName,
    required this.commentText,
    required this.image,
    required this.usershortDescription,
    this.textSize = 14,
    this.textColor = Colors.black87,
    this.textWeight = FontWeight.w400,
    this.lineHeight = 1.5,
    this.textAlign = TextAlign.start,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: ElevateColor.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: UserDescriptionShort(
                      imageURL: image,
                      name: userName,
                      shortDescription: usershortDescription,
                    ),
                  ),
                  IconTextButton(
                    text: "Follow",
                    iconData: Icons.send_rounded,
                    backgroundColor: Colors.transparent,
                    iconColor: ElevateColor.gray,
                    textColor: ElevateColor.gray,
                    textSize: 13,
                    iconSize: 18,
                    textWeight: FontWeight.w600,
                  ),
                ],
              ),

              const SizedBox(height: 15),

              CustomText(
                text: commentText,
                fontSize: textSize,
                color: textColor,
                fontWeight: textWeight,
                lineHeight: lineHeight,
                textAlign: textAlign,
                maxLines: maxLines,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
