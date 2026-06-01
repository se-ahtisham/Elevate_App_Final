import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/admin_portfolio_tile.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminSearchPortfolio extends StatefulWidget {
  const AdminSearchPortfolio({super.key});

  @override
  State<AdminSearchPortfolio> createState() => _AdminSearchPortfolioState();
}

class _AdminSearchPortfolioState extends State<AdminSearchPortfolio> {
  final List<String> portfolios = const [
    "E-Commerce\nMobile Application",
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 32;

    return Scaffold(
      backgroundColor: ElevateColor.white,
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            ElevateHeader(
              title: "Manage",
              subTitle: "Job Seeker",
              titleSize: 35,
              subtitleSize: 20,
            ),
            Expanded(
              child: Container(
                color: ElevateColor.white,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.hub_outlined,
                          size: 14,
                          color: ElevateColor.gray,
                        ),
                        SizedBox(width: 16),
                        CustomText(
                          text: "Explore Portfolio",
                          fontSize: 20,
                          color: ElevateColor.gray,
                          fontWeight: FontWeight.w700,
                          lineHeight: 1.0,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        color: ElevateColor.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFFE9E9E9)),
                      ),
                      child: CustomSearchBar(
                        hintText: "Ecommerce Mobile application",
                        iconData: Icons.search_rounded,
                        iconSize: 19,
                        iconColor: ElevateColor.gray,
                        iconTextSpacing: 8,
                        backgroundColor: Colors.transparent,
                        borderRadius: 30,
                        height: 40,
                        width: width,
                        textSize: 12,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: ListView.builder(
                        itemCount: portfolios.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AdminPortfolioTile(
                              title: portfolios[index],
                              onTap: () {},
                            ),
                          );
                        },
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
