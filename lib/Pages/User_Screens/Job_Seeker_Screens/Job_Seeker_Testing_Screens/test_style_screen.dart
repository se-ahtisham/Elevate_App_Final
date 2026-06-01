import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/short_description_round_circle_icon_tile.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/skill_test_tile.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Testing_Screens/experience_coding.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Testing_Screens/hard_coding.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Testing_Screens/vibe_coding.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:flutter/material.dart';

class TestStyleScreen extends StatelessWidget {
  const TestStyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: SafeArea(
        child: Column(
          children: [
            ElevateHeader(
              title: "Test Skills Type",
              subTitle: "Test smarter, grow faster, achieve more.",
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // here we will make the list of tiles
                      SkillTestTile(
                        title: 'HARD Coding',
                        subtitle: 'Pure coding test',
                        buttonText: 'START',
                        imagePath: 'lib/Resources/Images/java.png',
                        // optional
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HardCoding(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      SkillTestTile(
                        title: 'Vibe Coding',
                        subtitle: 'Pure coding test',
                        buttonText: 'START',
                        imagePath: 'lib/Resources/Images/chash.png', // optional
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VibeCoding(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      SkillTestTile(
                        title: 'Expert Coding',
                        subtitle: 'Pure coding test',
                        buttonText: 'START',
                        imagePath: 'lib/Resources/Images/chash.png', // optional
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExperienceCoding(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
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
