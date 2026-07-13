import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Drop_Down_Menu/custom_drop_down.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Navigations/job_seeker_bottom_navigation.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/Job_screen.dart';
import 'package:flutter/material.dart';

class NicheExpSelection extends StatefulWidget {
  const NicheExpSelection({super.key});

  @override
  State<NicheExpSelection> createState() => _NicheExpSelectionState();
}

class _NicheExpSelectionState extends State<NicheExpSelection> {
  String? niche;
  String? experience;

  final List<String> niches = [
    "Flutter",
    "Android",
    "iOS",
    "React Native",
    "Frontend",
    "Backend",
    "Full Stack",
    "DevOps",
    "Data Science",
    "Machine Learning",
    "UI/UX Design",
    "QA / Testing",
    "Product Manager",
    "Cybersecurity",
  ];

  final List<String> experiences = [
    "Intern",
    "Junior",
    "Mid-Level",
    "Senior",
    "Lead",
    "Manager",
  ];

  @override
  Widget build(BuildContext context) {
    bool isReady = niche != null && experience != null;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// SMALL TEXT
              const CustomText(
                text: "Find your",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
                textAlign: TextAlign.left,
              ),

              /// BIG TITLE
              const CustomText(
                text: "Dream Job",
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                textAlign: TextAlign.left,
              ),

              const SizedBox(height: 10),

              /// DESCRIPTION
              const CustomText(
                text:
                    "Select your niche and experience level to discover\n"
                    "personalized job opportunities tailored for you.",
                fontSize: 13,
                color: Colors.grey,
                textAlign: TextAlign.left,
                lineHeight: 1.5,
              ),

              const SizedBox(height: 40),

              /// DROPDOWNS
              CustomDropDown(
                hintText: "Select Niche",
                items: niches,
                value: niche,
                onChanged: (value) {
                  setState(() {
                    niche = value;
                  });
                },
              ),

              const SizedBox(height: 15),

              CustomDropDown(
                hintText: "Select Experience",
                items: experiences,
                value: experience,
                onChanged: (value) {
                  setState(() {
                    experience = value;
                  });
                },
              ),

              const SizedBox(height: 40),

              /// BUTTON (same size as dropdown feel)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButtonGradient(
                  text: "Search Jobs",
                  onTap: isReady
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JobSeekerBottomNavigation(
                                niche: niche!,
                                experience: experience!,
                              ),
                            ),
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
