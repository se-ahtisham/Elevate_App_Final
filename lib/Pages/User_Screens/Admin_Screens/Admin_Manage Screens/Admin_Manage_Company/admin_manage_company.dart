import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/manage_white_black_full.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Company/admin_add_company.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Company/admin_delete_company.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Company/admin_search_company.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Company/admin_update_company_profile.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/admin_manage.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminManageCompany extends StatelessWidget {
  const AdminManageCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            ElevateHeader(
              title: "Manage",
              subTitle: "Company",
              titleSize: 40,
              subtitleSize: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    TexxtButton(
                      text: "Add Company",
                      height: 50,
                      textSize: 14,
                      textColor: ElevateColor.gray,
                      textWeight: FontWeight.w400,
                      borderRadius: 50,
                      backgroundColor: Colors.transparent,
                      borderColor: ElevateColor.gray,
                      borderWidth: 1,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminAddCompanyScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 35),
                    TexxtButton(
                      text: "Search Company",
                      height: 50,
                      textSize: 14,
                      textColor: ElevateColor.gray,
                      textWeight: FontWeight.w400,
                      borderRadius: 50,
                      backgroundColor: Colors.transparent,
                      borderColor: ElevateColor.gray,
                      borderWidth: 1,

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminSearchCompany(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 35),
                    TexxtButton(
                      text: "Update Company",
                      height: 50,
                      textSize: 14,
                      textColor: ElevateColor.gray,
                      textWeight: FontWeight.w400,
                      borderRadius: 50,
                      backgroundColor: Colors.transparent,
                      borderColor: ElevateColor.gray,
                      borderWidth: 1,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminUpdateCompanyProfile(),
                          ),
                        );
                      },
                    ),
                     SizedBox(height: 35),
                    TexxtButton(
                      text: "Delete Company",
                      height: 50,
                      textSize: 14,
                      textColor: ElevateColor.gray,
                      textWeight: FontWeight.w400,
                      borderRadius: 50,
                      backgroundColor: Colors.transparent,
                      borderColor: ElevateColor.gray,
                      borderWidth: 1,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminDeleteCompany(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 35),
                    TextButtonGradient(
                      text: "Back",
                      height: 50,
                      textSize: 14,
                      textWeight: FontWeight.w400,
                      borderRadius: 50,
                       onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminManage(),
                          ),
                        );
                        }
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
