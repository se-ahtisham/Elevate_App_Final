import 'package:elevate_app/Custom_Widgets/Tiles/skill_card.dart';
import 'package:elevate_app/Data_Model_Classes/api_skill_model.dart';
import 'package:elevate_app/Services/skill_api_Services.dart';
import 'package:flutter/material.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
/*
class AllTrendingSkillsScreen extends StatefulWidget {
  const AllTrendingSkillsScreen({super.key});

  @override
  State<AllTrendingSkillsScreen> createState() =>
      _AllTrendingSkillsScreenState();
}

class _AllTrendingSkillsScreenState extends State<AllTrendingSkillsScreen> {
  // List<SkillModel> skills = [];
  @override
  void initState() {
    super.initState();
    // loadSkills();
  }

  /*
  Future<void> loadSkills() async {
    skills = await SkillApiServices.fetchTrendingSkills();
    setState(() {});
  }
*/
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
          ),

          Expanded(
            child: /* skills.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                : */ ListView.builder(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
              //itemCount: skills.length,
              itemBuilder: (context, index) {
                //final skill = skills[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SkillCard(
                      title: "UI/UX Designer Noobody",
                      company: "Microsoft",
                      location: "USA",
                      startingSalary: "600",
                      endingSalary: "900",
                    ) /*SkillCard(
                            title: skill.title,
                            company: skill.company,
                            location: skill.location,
                            startingSalary: skill.salaryStart.toString(),
                            endingSalary: skill.salaryEnd.toString(),
                          ),*/,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
*/

class AllTrendingSkillsScreen extends StatefulWidget {
  const AllTrendingSkillsScreen({super.key});

  @override
  State<AllTrendingSkillsScreen> createState() =>
      _AllTrendingSkillsScreenState();
}

class _AllTrendingSkillsScreenState extends State<AllTrendingSkillsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
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
              itemCount: 10, // temporary static count
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 15),
                  child: SkillCard(
                    title: "UI/UX Designer Noobody",
                    company: "Microsoft",
                    location: "USA",
                    startingSalary: "600",
                    endingSalary: "900",
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
