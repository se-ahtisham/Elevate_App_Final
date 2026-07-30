import 'package:elevate_app/Custom_Widgets/Buttons/icon_text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/skill_card.dart';
import 'package:elevate_app/Data_Model_Classes/Api_Models/api_skill_model.dart';
import 'package:elevate_app/Services/skill_api_Services.dart';
import 'package:flutter/material.dart';

class AllTrendingSkillsScreen extends StatefulWidget {
  const AllTrendingSkillsScreen({super.key});

  @override
  State<AllTrendingSkillsScreen> createState() =>
      _AllTrendingSkillsScreenState();
}

class _AllTrendingSkillsScreenState extends State<AllTrendingSkillsScreen> {
  List<SkillModel> skills = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadSkills();
  }

  Future<void> loadSkills() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedSkills = await SkillApiServices.fetchTrendingSkills();
      if (!mounted) return;

      setState(() {
        skills = fetchedSkills;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          const ElevateHeader(
            title: "Hot Skills",
            subTitle: "Practice the skills shaping the tech market",
            titleSize: 35,
            subtitleSize: 15,
            showBackButton: true,
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                : errorMessage != null && skills.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Failed to load skills",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 16),
                          IconTextButtonGradient(
                            text: "Retry API",
                            iconData: Icons.refresh,
                            startColor: const Color(0xFF595959),
                            endColor: const Color(0xFF111111),
                            borderRadius: 30,
                            height: 44,
                            width: 140,
                            onTap: loadSkills,
                          ),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: loadSkills,
                    color: Colors.black,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: 30,
                        right: 30,
                        bottom: 20,
                        top: 10,
                      ),
                      itemCount: skills.length,
                      itemBuilder: (context, index) {
                        final skill = skills[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: SkillCard(
                            title: skill.title,
                            company: skill.company,
                            location: skill.location,
                            startingSalary: skill.salaryStart.toString(),
                            endingSalary: skill.salaryEnd.toString(),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 30,
            right: 30,
            bottom: 20,
            top: 10,
          ),
          child: IconTextButtonGradient(
            text: "Refresh Skills",
            iconData: Icons.refresh,
            iconSize: 20,
            iconColor: Colors.white,
            textSize: 15,
            textWeight: FontWeight.w600,
            textColor: Colors.white,
            borderRadius: 30,
            height: 50,
            startColor: const Color(0xFF595959),
            endColor: const Color(0xFF111111),
            onTap: isLoading ? null : loadSkills,
          ),
        ),
      ),
    );
  }
}

/*import 'package:elevate_app/Custom_Widgets/Buttons/icon_text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/skill_card.dart';
import 'package:flutter/material.dart';

class AllTrendingSkillsScreen extends StatelessWidget {
  const AllTrendingSkillsScreen({super.key});

  static final List<Map<String, String>> dummySkills = [
    {
      "title": "AI Engineer",
      "company": "Google",
      "location": "USA",
      "startingSalary": "95000",
      "endingSalary": "160000",
    },
    {
      "title": "Flutter Developer",
      "company": "Spotify",
      "location": "Remote",
      "startingSalary": "70000",
      "endingSalary": "120000",
    },
    {
      "title": "Cloud Architect",
      "company": "Amazon",
      "location": "Seattle, USA",
      "startingSalary": "110000",
      "endingSalary": "180000",
    },
    {
      "title": "Data Scientist",
      "company": "Meta",
      "location": "London, UK",
      "startingSalary": "90000",
      "endingSalary": "150000",
    },
    {
      "title": "Cybersecurity Analyst",
      "company": "Microsoft",
      "location": "Remote",
      "startingSalary": "80000",
      "endingSalary": "135000",
    },
    {
      "title": "DevOps Engineer",
      "company": "Netflix",
      "location": "USA",
      "startingSalary": "85000",
      "endingSalary": "145000",
    },
    {
      "title": "Machine Learning Engineer",
      "company": "OpenAI",
      "location": "Remote",
      "startingSalary": "100000",
      "endingSalary": "170000",
    },
    {
      "title": "Mobile App Developer",
      "company": "Uber",
      "location": "San Francisco, USA",
      "startingSalary": "75000",
      "endingSalary": "130000",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          const ElevateHeader(
            title: "Hot Skills",
            subTitle: "Practice the skills shaping the tech market",
            titleSize: 35,
            subtitleSize: 15,
            showBackButton: true,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
                bottom: 20,
                top: 10,
              ),
              itemCount: dummySkills.length,
              itemBuilder: (context, index) {
                final skill = dummySkills[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 30,
            right: 30,
            bottom: 20,
            top: 10,
          ),
          child: IconTextButtonGradient(
            text: "Refresh Skills",
            iconData: Icons.refresh,
            iconSize: 20,
            iconColor: Colors.white,
            textSize: 15,
            textWeight: FontWeight.w600,
            textColor: Colors.white,
            borderRadius: 30,
            height: 50,
            startColor: const Color(0xFF595959),
            endColor: const Color(0xFF111111),
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
*/
