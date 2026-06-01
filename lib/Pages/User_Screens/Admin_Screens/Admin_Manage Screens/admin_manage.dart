import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/manage_white_black_full.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Badges/admin_badge_management.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Community/admin_community_management.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Company/admin_manage_company.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Job/admin_search_jobs.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Job_seeker/admin_add_job_seeker_screen.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Job_seeker/admin_manage_job_seeker.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Portfolio/admin_search_portfolio.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminManage extends StatelessWidget {
  const AdminManage({super.key});

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
              title: "Now It's",
              subTitle: "Your Time",
              titleSize: 40,
              subtitleSize: 18,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ManageWhiteBlackFull(
                        titleText: 'Manage',
                        subtitleText: 'JOB SEEKERS',
                        firstContainerWidth: 240,
                        titleFontSize: 23,
                        subtitleFontSize: 30,
                        tileHeight: 100,
                        lineHeight: 1,
                        firstContainerColor: ElevateColor.white,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminManageJobSeeker(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      ManageWhiteBlackFull(
                        titleText: 'Manage',
                        subtitleText: 'COMPANIES',
                        firstContainerWidth: 240,
                        titleFontSize: 23,
                        subtitleFontSize: 30,
                        tileHeight: 100,
                        lineHeight: 1,
                        firstContainerColor: ElevateColor.white,

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminManageCompany(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      ManageWhiteBlackFull(
                        titleText: 'Manage',
                        subtitleText: 'JOBS',
                        firstContainerWidth: 240,
                        titleFontSize: 23,
                        subtitleFontSize: 30,
                        tileHeight: 100,
                        lineHeight: 1,
                        firstContainerColor: ElevateColor.white,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminSearchJobs(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      ManageWhiteBlackFull(
                        titleText: 'Manage',
                        subtitleText: 'SKILLS',
                        firstContainerWidth: 240,
                        titleFontSize: 23,
                        subtitleFontSize: 30,
                        tileHeight: 100,
                        lineHeight: 1,
                        firstContainerColor: ElevateColor.white,
                      ),
                      SizedBox(height: 20),
                      ManageWhiteBlackFull(
                        titleText: 'Manage',
                        subtitleText: 'BADGES',
                        firstContainerWidth: 240,
                        titleFontSize: 23,
                        subtitleFontSize: 30,
                        tileHeight: 100,
                        lineHeight: 1,
                        firstContainerColor: ElevateColor.white,
                         onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminBadgeManagement(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      ManageWhiteBlackFull(
                        titleText: 'Manage',
                        subtitleText: 'PORTFOLIOS',
                        firstContainerWidth: 240,
                        titleFontSize: 23,
                        subtitleFontSize: 30,
                        tileHeight: 100,
                        lineHeight: 1,
                        firstContainerColor: ElevateColor.white,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminSearchPortfolio(),
                            ),
                          );
                        },
                      ),
            
                      SizedBox(height: 20),
                      ManageWhiteBlackFull(
                        titleText: 'Manage',
                        subtitleText: 'COMMUNITY',
                        firstContainerWidth: 240,
                        titleFontSize: 23,
                        subtitleFontSize: 30,
                        tileHeight: 100,
                        lineHeight: 1,
                        firstContainerColor: ElevateColor.white,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminCommunityManagement(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
