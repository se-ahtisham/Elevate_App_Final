import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/employee_request_tile.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class ComapanyEmployeeRequest extends StatelessWidget {
  const ComapanyEmployeeRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconText(
                text: "Explore Request",
                iconData: Icons.people,
                textWeight: FontWeight.w600,
                iconSize: 25,
                textSize: 17,
              ),
              SizedBox(height: 25),
              CustomSearchBar(
                hintText: "Muhammad Ahtisham",
                backgroundColor: ElevateColor.white,
                width: 330,
                height: 50,
                textSize: 15,
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      EmployeeRequestTile(
                        height: 120,
                        width: 330,
                        backgroundColor: ElevateColor.white,
                        borderRadius: 20,
                        imageURL:
                            'lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg',
                        name: 'Muhammad Ahtisham',
                        shortDescription: 'Software Engineer',
                        acceptonTap: null,
                        rejectonTap: null,
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
