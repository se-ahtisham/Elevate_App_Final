import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description_short.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';


/*UserPostNew
└── Container (width: 350, white,)
    └── Padding (vertical: 20, horizontal: 25)
        └── SingleChildScrollView
            └── Column (crossAxisAlignment: start)
                ├── Row
                │   └── Expanded
                │       └── UserDescriptionShort
                ├── SizedBox (height: 20)
                ├── CustomTextField (Title Field)
                │   ├── controller: titleController
                │   └── hintText: hintTitle
                ├── SizedBox (height: 30)
                ├── CustomTextField (Description Field)
                │   ├── controller: shortdescriptionController
                │   └── hintText: hintText
                ├── SizedBox (height: 30)
                ├── TextButtonGradient ("POST NOW")
                └── SizedBox (height: 20) */

class UserPostNew extends StatelessWidget {
  final String hintTitle;
  final String hintText;
  final String imageURL;
  final String name;
  final String shortDescription;
  final TextEditingController titleController;
  final TextEditingController shortDescriptionController;
  final VoidCallback? onPost;
  final Color borderColor;
  final int borderSize;

  const UserPostNew({
    super.key,
    required this.hintTitle,
    required this.hintText,
    required this.imageURL,
    required this.name,
    this.shortDescription = "",
    required this.titleController,
    required this.shortDescriptionController,
    this.onPost,
    this.borderColor = ElevateColor.gray,
    this.borderSize = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: ElevateColor.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: borderSize.toDouble(),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserDescriptionShort(
                imageURL: imageURL,
                name: name,
                shortDescription: shortDescription,
              ),
          
              SizedBox(height: 20),
          
              CustomTextField(
                controller: titleController,
                hintText: hintTitle,
                cursorColor: ElevateColor.lightgray,
                underlineColor: ElevateColor.lightgray,
                textColor: ElevateColor.white,
              ),
          
              SizedBox(height: 30),
          
              CustomTextField(
                controller: shortDescriptionController,
                hintText: hintText,
                cursorColor: ElevateColor.lightgray,
                underlineColor: ElevateColor.lightgray,
                textColor: ElevateColor.white,
              ),
          
              SizedBox(height: 30),
          
              TextButtonGradient(
                text: "POST NOW",
                onTap: onPost,
              ),
          
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}