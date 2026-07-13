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
  State<AdminBottomNavigation> createState() => _AdminBottomNavigationState();
}

class _AdminBottomNavigationState extends State<AdminBottomNavigation> {
  int currentIndex = 0;

  // one key per tab, stored so we can use it later
  final GlobalKey<NavigatorState> dashboardKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> manageKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> profileKey = GlobalKey<NavigatorState>();

  late final List<Widget> screens = [
    Navigator(
      key: dashboardKey,
      onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
    ),
    Navigator(
      key: manageKey,
      onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (_) => const AdminManage()),
    ),
    Navigator(
      key: profileKey,
      onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (_) => const AdminProfileScreen()),
    ),
  ];

  final List<Map<String, String>> navItems = const [
    {'icon': 'lib/Resources/Icons/Home.svg', 'label': 'Dashboard'},
    {'icon': 'lib/Resources/Icons/Portfolio.svg', 'label': 'Manage'},
    {'icon': 'lib/Resources/Icons/Profile.svg', 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = View.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: isKeyboardOpen
          ? null
          : Padding(
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
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: List.generate(navItems.length, (i) {
                    final item = navItems[i];
                    final bool selected = currentIndex == i;

                    return Expanded(
                      child: InkWell(
                        onTap: () {
                          if (currentIndex == i) return;
                          setState(() => currentIndex = i);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedScale(
                              scale: selected ? 1.2 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: SvgPicture.asset(
                                item['icon']!,
                                height: 22,
                                colorFilter: ColorFilter.mode(
                                  selected ? Colors.black : Colors.grey,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (selected)
                              CustomText(
                                text: item['label']!,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
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
