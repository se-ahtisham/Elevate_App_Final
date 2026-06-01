import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/PortfolioCard.dart';
import 'package:flutter/material.dart';

class CompanyPortfolioCheck extends StatefulWidget {
  const CompanyPortfolioCheck({super.key});

  @override
  State<CompanyPortfolioCheck> createState() =>
      _CompanyPortfolioCheckState();
}

class _CompanyPortfolioCheckState extends State<CompanyPortfolioCheck> {
  int currentIndex = 0;

  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> portfolioList = [
    {
      "title": "E-Commerce\nMobile Application",
      "desc": "A mobile platform for online shopping",
      "role": "Lead Developer",
    },
    {
      "title": "Food Delivery\nApplication",
      "desc": "Fast and reliable food delivery system",
      "role": "Backend Developer",
    },
    {
      "title": "Chat Application",
      "desc": "Real-time messaging app",
      "role": "Flutter Developer",
    },
    {
      "title": "Portfolio Website",
      "desc": "Personal branding website",
      "role": "Frontend Developer",
    },
    {
      "title": "Portfolio Website",
      "desc": "Personal branding website",
      "role": "Frontend Developer",
    },

    {
      "title": "Portfolio Website",
      "desc": "Personal branding website",
      "role": "Frontend Developer",
    },

    {
      "title": "Portfolio Website",
      "desc": "Personal branding website",
      "role": "Frontend Developer",
    },
    {
      "title": "Portfolio Website",
      "desc": "Personal branding website",
      "role": "Frontend Developer",
    },
  ];

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      double offset = _scrollController.offset;

      double itemHeight = 180;

      int newIndex = (offset / itemHeight).round();

      if (newIndex != currentIndex &&
          newIndex >= 0 &&
          newIndex < portfolioList.length) {
        setState(() {
          currentIndex = newIndex;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ElevateHeader(
              title: "MOIZ PORTFOLIO",
              subTitle: "Showcasing your proven technical abilities",
            ),

            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: portfolioList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = portfolioList[index];
                  final bool isActive = currentIndex == index;

                  return AnimatedScale(
                    scale: isActive ? 1.0 : 0.95,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: PortfolioCard(
                        isActive: isActive,
                        title: item["title"]!,
                        description: item["desc"]!,
                        role: item["role"]!,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
