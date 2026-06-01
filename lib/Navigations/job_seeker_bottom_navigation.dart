import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Community_Screens/user_community_screen.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/Job_screen.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Portfolio_Screens/porfolio_screen.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Profile_Screens/job_Seeker_profile_screen.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Testing_Screens/test_screen.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class JobSeekerBottomNavigation extends StatefulWidget {
  final String niche;
  final String experience;

  const JobSeekerBottomNavigation({
    super.key,
    required this.niche,
    required this.experience,
  });

  @override
  State<JobSeekerBottomNavigation> createState() =>
      _JobSeekerBottomNavigationState();
}

class _JobSeekerBottomNavigationState extends State<JobSeekerBottomNavigation> {
  int currentIndex = 0;
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = [
      Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) =>
              JobScreen(niche: widget.niche, experience: widget.experience),
        ),
      ),
      Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (_) =>
            MaterialPageRoute(builder: (_) => const TestScreen()),
      ),
      Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (_) =>
            MaterialPageRoute(builder: (_) => const UserCommunityScreen()),
      ),
      Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (_) =>
            MaterialPageRoute(builder: (_) => const PorfolioScreen()),
      ),
      Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (_) =>
            MaterialPageRoute(builder: (_) => const JobSeekerProfileScreen()),
      ),
    ];
  }

  final List<Map<String, String>> navItems = const [
    {'icon': 'lib/Resources/Icons/Home.svg', 'label': 'Home'},
    {'icon': 'lib/Resources/Icons/Test.svg', 'label': 'Tests'},
    {'icon': 'lib/Resources/Icons/Network.svg', 'label': 'Network'},
    {'icon': 'lib/Resources/Icons/Portfolio.svg', 'label': 'Portfolio'},
    {'icon': 'lib/Resources/Icons/Profile.svg', 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: IndexedStack(index: currentIndex, children: screens),

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
