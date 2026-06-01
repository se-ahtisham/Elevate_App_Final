import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:flutter/material.dart';

/*TopNavigation
└── DefaultTabController (length: titles.length)
    └── Column
        ├── Padding (vertical: 8)
        │   └── TabBar
        │       ├── isScrollable: true
        │       ├── indicatorSize: TabBarIndicatorSize.tab
        │       ├── indicator: BoxDecoration (gradient: grayToBlack, borderRadius: 30)
        │       ├── labelColor: white
        │       ├── unselectedLabelColor: grey
        │       ├── labelPadding: EdgeInsets(horizontal: 20)
        │       └── Tabs (one for each title)
        │           └── Tab
        │               └── CustomText (text: title, fontWeight: w500)
        └── Expanded
            └── TabBarView
                └── screens (children: widgets corresponding to each tab) */

class CommunityNavigation extends StatelessWidget {
  final List<String> titles;
  final List<Widget> screens;

  const CommunityNavigation({
    super.key,
    required this.titles,
    required this.screens,
  }) : assert(titles.length == screens.length); // Condition to check both equal

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: titles.length,
        initialIndex: 0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TabBar(
              isScrollable: true,
                indicator: BoxDecoration(
                gradient: ElevateGradientColors.grayToBlack,
                borderRadius: BorderRadius.circular(30),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.symmetric(vertical: 5),
              labelColor: Colors.white,
              dividerColor: Colors.transparent,
              tabAlignment: TabAlignment.start,
              unselectedLabelColor: const Color.fromARGB(255, 54, 54, 54),
              labelPadding: const EdgeInsets.symmetric(horizontal: 20),
              tabs: titles.map((title) {
                return Tab(
                  child: CustomText(
                    text: title,
                    color: null,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: BouncingScrollPhysics(),
              children: screens,
            ),
          ),
        ],
      ),
    );
  }
}