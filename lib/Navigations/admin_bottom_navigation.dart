import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Dashboard_Screens/admin_dashboard_screen.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/admin_manage.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Profile_Screen/admin_profile_screen.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdminBottomNavigation extends StatefulWidget {
  const AdminBottomNavigation({super.key});

  @override
  _AdminBottomNavigationState createState() =>
      _AdminBottomNavigationState();
}

class _AdminBottomNavigationState extends State<AdminBottomNavigation> {
  int currentIndex = 0;

  final screens = [
    AdminDashboardScreen(),
    AdminManage(),
    AdminProfileScreen(),

  ];

final navItems = [
  {'icon': 'lib/Resources/Icons/Home.svg', 'label': 'Overview'},
  {'icon': 'lib/Resources/Icons/Manage.svg', 'label': 'Manage'},
  {'icon': 'lib/Resources/Icons/Profile.svg', 'label': 'Profile'},
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: ElevateColor.gray),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(30),
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: List.generate(navItems.length, (i) {
              final item = navItems[i];
              bool selected = currentIndex == i;

              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => currentIndex = i),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedScale(
                        scale: selected ? 1.3 : 1.0,
                        duration: Duration(milliseconds: 200),
                        child: SvgPicture.asset(
                          item['icon'] as String,
                          height: 22,
                          colorFilter: ColorFilter.mode(
                            selected ? Colors.black : Colors.grey,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),

                      if (selected) ...[
                        SizedBox(height: 4),
                        CustomText(text: item['label'] as String,fontSize: 10,fontWeight: FontWeight.w600)
                        
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}