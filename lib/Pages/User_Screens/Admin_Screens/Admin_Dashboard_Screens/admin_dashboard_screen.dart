import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Navigation_Bar/admin_bottom_nav.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/admin_card.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/admin_total_stat_tile.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = const [
      ("Total", "Job Seekers", 121),
      ("Total", "Companies", 12),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: ElevateColor.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ElevateHeader(
                    title: "Welcome Ahtisham",
                    subTitle: "Check the Statictics",
                    titleSize: 22,
                    subtitleSize: 10,

                  );
                },
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                width: double.infinity,
                color: const Color(0xFFEAEAEA),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: cards.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 60,
                              child: Row(
                                children: [
                                  _TopMetric(value: "10", label: "Skills"),
                                  Container(
                                    width: 1,
                                    height: 34,
                                    color: const Color(0xFFC8C8C8),
                                    margin: const EdgeInsets.symmetric(horizontal: 22),
                                  ),
                                  _TopMetric(value: "238", label: "Jobs"),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      }

                      final card = cards[index - 1];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AdminTotalStatTile(
                          prefix: card.$1,
                          title: card.$2,
                          count: card.$3,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(activeIndex: 0),
    );
  }
}

class _TopMetric extends StatelessWidget {
  final String value;
  final String label;

  const _TopMetric({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: value,
          fontSize: 26,
          color: ElevateColor.gray,
          fontWeight: FontWeight.w400,
          lineHeight: 1.0,
        ),
        const SizedBox(height: 2),
        CustomText(
          text: label,
          fontSize: 11,
          color: const Color(0xFF9C9C9C),
          fontWeight: FontWeight.w500,
          lineHeight: 1.0,
        ),
      ],
    );
  }
}*/

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevateHeader(
              title: "Ahtisham Dashboard",
              subTitle: "Check the Statictics",
            ),

            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 40, bottom: 20),
              child: Container(
                height: 50,
                width: 370,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: CustomText(
                    text: "App Performance Metrics",
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            Expanded(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AdminCard(
                        topText: "Total",
                        bottomText: "Job Seekers",
                        count: 121,
                      ),
                      SizedBox(height: 20),
                      AdminCard(
                        topText: "Total",
                        bottomText: "Companies",
                        count: 12,
                      ),
                      SizedBox(height: 20),
                      AdminCard(
                        topText: "Total",
                        bottomText: "Skills",
                        count: 12,
                      ),
                      SizedBox(height: 30),
                      AdminCard(
                        topText: "Total",
                        bottomText: "Jobs",
                        count: 120,
                      ),
                      SizedBox(height: 20),
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
