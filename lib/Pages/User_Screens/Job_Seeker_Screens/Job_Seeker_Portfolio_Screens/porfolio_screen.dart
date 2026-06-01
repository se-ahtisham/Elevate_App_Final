import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/PortfolioCard.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Portfolio_Screens/job_seeker_portfolio_description_screen.dart';
import 'package:flutter/material.dart';

class PorfolioScreen extends StatefulWidget {
  const PorfolioScreen({super.key});

  @override
  State<PorfolioScreen> createState() => _PorfolioScreenState();
}

class _PorfolioScreenState extends State<PorfolioScreen> {
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
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Stack(
            children: [
              const ElevateHeader(
                title: "MOIZ PORTFOLIO",
                subTitle: "Showcasing your proven technical abilities",
              ),

              Padding(
                padding: const EdgeInsets.only(left: 220, top: 70),
                child: TexxtButton(
                  text: "New Project",
                  textSize: 13,
                  textColor: Colors.white,
                  textWeight: FontWeight.w500,
                  backgroundColor: const Color.fromARGB(144, 155, 155, 155),
                  borderRadius: 30,
                  borderWidth: 1,
                  height: 50,
                  width: 150,
                  onTap: () {},
                ),
              ),
            ],
          ),

          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: portfolioList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = portfolioList[index];
                final bool isActive = currentIndex == index;

                return PortfolioCard(
                  isActive: isActive,
                  title: item["title"]!,
                  description: item["desc"]!,
                  role: item["role"]!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            JobSeekerPortfolioDescriptionScreen(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
