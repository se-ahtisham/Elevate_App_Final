import 'package:elevate_app/Custom_Widgets/Buttons/circle_icon_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/short_description_round_circle_icon_tile.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/Company_View_Employee_Profile.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/comapany_employee_request.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*CompanyHomeScreen
└── Scaffold (extendBodyBehindAppBar: true, backgroundColor: #F1F1F1)
    └── AnnotatedRegion<SystemUiOverlayStyle.light>
        └── Column
            ├── ElevateHeader
            │   ├── title: "Dashboard"
            │   └── subTitle: "Manage Employees in one place"
            └── Expanded
                └── Padding (horizontal: 30, vertical: 10)
                    └── Column (crossAxisAlignment: start)
                        ├── Row
                        │   ├── CustomSearchBar ("Search Employee")
                        │   └── CircleIconButton (person_add)
                        ├── SizedBox (height: 20)
                        ├── CustomText ("WORKING EMPLOYEE")
                        ├── SizedBox (height: 20)
                        └── Expanded
                            └── SingleChildScrollView
                                └── Column
                                    ├── Shortdescriptionroundcircleicontiletile (Ahtisham)
                                    ├── Shortdescriptionroundcircleicontiletile (Ahtisham)
                                    ├── Shortdescriptionroundcircleicontiletile (Ahtisham)
                                    └── Shortdescriptionroundcircleicontiletiletile (Ahtisham) */

class CompanyHomeScreen extends StatelessWidget {
  const CompanyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            ElevateHeader(
              title: "Dashboard",
              subTitle: "Manage Employees in one place",
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomSearchBar(
                          hintText: "Search Employee",
                          backgroundColor: ElevateColor.white,
                          width: 270,
                          height: 50,
                          textSize: 15,
                        ),

                        Expanded(
                          child: CircleIconButton(
                            iconData: Icons.person_add,
                            circleSize: 50,
                            circleColor: ElevateColor.lightgray,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ComapanyEmployeeRequest(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    CustomText(
                      text: "WORKING EMPLOYEE",
                      fontSize: 22,
                      color: ElevateColor.gray,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.left,
                      lineHeight: 1.3,
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ShortDescriptionRoundCircleIconTile(
                              height: 80,
                              width: 350,
                              backgroundColor: ElevateColor.white,
                              borderRadius: 12,
                              imageURL:
                                  'lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg',
                              name: 'Ahtisham',
                              shortDescription: 'Software Engineer',
                              iconData: Icons.arrow_forward,
                              iconSize: 24,
                              iconColor: Colors.white,
                              circleSize: 50,
                              circleColor: ElevateColor.lightgray,
                              borderWidth: 2,
                              borderColor: ElevateColor.lightgray,

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CompanyViewEmployeeProfile(),
                                  ),
                                );
                              },
                            ),
                            ShortDescriptionRoundCircleIconTile(
                              height: 80,
                              width: 350,
                              backgroundColor: ElevateColor.white,
                              borderRadius: 12,
                              imageURL:
                                  'lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg',
                              name: 'Ahtisham',
                              shortDescription: 'Software Engineer',
                              iconData: Icons.arrow_forward,
                              iconSize: 24,
                              iconColor: Colors.white,
                              circleSize: 50,
                              circleColor: ElevateColor.lightgray,
                              borderWidth: 2,
                              borderColor: ElevateColor.lightgray,

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CompanyViewEmployeeProfile(),
                                  ),
                                );
                              },
                            ),
                            ShortDescriptionRoundCircleIconTile(
                              height: 80,
                              width: 350,
                              backgroundColor: ElevateColor.white,
                              borderRadius: 12,
                              imageURL:
                                  'lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg',
                              name: 'Ahtisham',
                              shortDescription: 'Software Engineer',
                              iconData: Icons.arrow_forward,
                              iconSize: 24,
                              iconColor: Colors.white,
                              circleSize: 50,
                              circleColor: ElevateColor.lightgray,
                              borderWidth: 2,
                              borderColor: ElevateColor.lightgray,

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CompanyViewEmployeeProfile(),
                                  ),
                                );
                              },
                            ),
                            ShortDescriptionRoundCircleIconTile(
                              height: 80,
                              width: 350,
                              backgroundColor: ElevateColor.white,
                              borderRadius: 12,
                              imageURL:
                                  'lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg',
                              name: 'Ahtisham',
                              shortDescription: 'Software Engineer',
                              iconData: Icons.arrow_forward,
                              iconSize: 24,
                              iconColor: Colors.white,
                              circleSize: 50,
                              circleColor: ElevateColor.lightgray,
                              borderWidth: 2,
                              borderColor: ElevateColor.lightgray,

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CompanyViewEmployeeProfile(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
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
