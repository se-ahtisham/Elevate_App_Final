import 'package:elevate_app/Custom_Widgets/Tiles/skill_card.dart';
import 'package:flutter/material.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';

class AllTrendingSkillsScreen extends StatefulWidget {
  const AllTrendingSkillsScreen({super.key});

  @override
  State<AllTrendingSkillsScreen> createState() => _AllTrendingSkillsScreenState();
}

class _AllTrendingSkillsScreenState extends State<AllTrendingSkillsScreen> {
  final List<Map<String, String>> trendingSkills = const [
    {
      "title": "UI/UX Designer",
      "company": "Microsoft",
      "location": "USA",
      "startingSalary": "600",
      "endingSalary": "900",
    },
    {
      "title": "Flutter Developer",
      "company": "Google",
      "location": "Canada",
      "startingSalary": "700",
      "endingSalary": "1000",
    },
    {
      "title": "Backend Engineer",
      "company": "Amazon",
      "location": "UK",
      "startingSalary": "800",
      "endingSalary": "1200",
    },
    {
      "title": "Data Analyst",
      "company": "Meta",
      "location": "USA",
      "startingSalary": "500",
      "endingSalary": "850",
    },
    {
      "title": "Product Manager",
      "company": "Apple",
      "location": "USA",
      "startingSalary": "900",
      "endingSalary": "1400",
    },
    {
      "title": "DevOps Engineer",
      "company": "Netflix",
      "location": "Germany",
      "startingSalary": "750",
      "endingSalary": "1100",
    },
    {
      "title": "Graphic Designer",
      "company": "Adobe",
      "location": "Australia",
      "startingSalary": "400",
      "endingSalary": "700",
    },
    {
      "title": "Content Writer",
      "company": "Spotify",
      "location": "Sweden",
      "startingSalary": "350",
      "endingSalary": "600",
    },
    {
      "title": "Mobile App Developer",
      "company": "Samsung",
      "location": "South Korea",
      "startingSalary": "650",
      "endingSalary": "950",
    },
    {
      "title": "AI/ML Engineer",
      "company": "OpenAI",
      "location": "USA",
      "startingSalary": "1000",
      "endingSalary": "1600",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const ElevateHeader(
              title: "Hot Skills",
              subTitle: "Practice the skills shaping the tech market",
              titleSize: 35,
              subtitleSize: 15,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                itemCount: trendingSkills.length,
                itemBuilder: (context, index) {
                  final skill = trendingSkills[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 15),
                    child: SkillCard(
                      title: skill["title"]!,
                      company: skill["company"]!,
                      location: skill["location"]!,
                      startingSalary: skill["startingSalary"]!,
                      endingSalary: skill["endingSalary"]!,
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
