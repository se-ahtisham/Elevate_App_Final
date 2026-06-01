import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/skill_test_tile.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Testing_Screens/job_seeker_task_management.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Stack(
            children: [
              ElevateHeader(
                title: "Test Your Skills",
                subTitle: "Test smarter, grow faster, achieve more.",
              ),

              Padding(
                padding: const EdgeInsets.only(left: 200.0, top: 60),
                child: TextButtonGradient(
                  text: "Guidance Manager",
                  width: 200,
                  height: 50,
                  textSize: 14,
                  textWeight: FontWeight.bold,
                  borderRadius: 50,
                  textColor: Colors.black,
                  buttonBackgroundColor: ElevateGradientColors.white,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobSeekerTaskManagement(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkillTestTile(
                      title: 'JAVA Development',
                      subtitle: 'Write Once, Run Anywhere',
                      buttonText: 'START',
                      imagePath: 'lib/Resources/Images/java.png',
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),

                    SkillTestTile(
                      title: 'Python Development',
                      subtitle: 'Readability and Simplicity',
                      buttonText: 'START',
                      imagePath: 'lib/Resources/Images/java.png',
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),

                    SkillTestTile(
                      title: 'C# development',
                      subtitle: 'High-performance',
                      buttonText: 'START',
                      imagePath: 'lib/Resources/Images/chash.png',
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
