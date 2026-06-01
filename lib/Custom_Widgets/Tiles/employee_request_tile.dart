import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_description_short.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class EmployeeRequestTile extends StatelessWidget {
  final double height;
  final double width;
  final Color? backgroundColor;
  final double borderRadius;
  final VoidCallback? acceptonTap;
  final VoidCallback? rejectonTap;

  final String imageURL;
  final String name;
  final String shortDescription;

  const EmployeeRequestTile({
    super.key,
    required this.height,
    required this.width,
    this.backgroundColor,
    this.borderRadius = 12,
    this.rejectonTap,
    this.acceptonTap,
    required this.imageURL,
    required this.name,
    required this.shortDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
        child: Column(
          children: [
            UserDescriptionShort(
              imageURL: imageURL,
              name: name,
              shortDescription: shortDescription,
            ),
            SizedBox(height: 10),
            Expanded(
              child: Row(
                children: [
                  TexxtButton(
                    text: "Reject",
                    height: 30,
                    width: 130,
                    textSize: 11,
                    textColor: ElevateColor.gray,
                    textWeight: FontWeight.bold,
                    borderRadius: 50,
                    backgroundColor: const Color.fromARGB(255, 230, 230, 230),
                    borderWidth: 0,
                    onTap: null,
                  ),
                  SizedBox(width: 10),
                  TextButtonGradient(
                    text: "Accept",
                    width: 130,
                    height: 30,
                    textSize: 11,
                    textWeight: FontWeight.bold,
                    borderRadius: 50,
                    onTap: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
