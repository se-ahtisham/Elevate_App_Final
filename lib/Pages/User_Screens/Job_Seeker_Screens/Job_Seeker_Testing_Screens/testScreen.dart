import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/skill_test_tile.dart';
import 'package:flutter/material.dart';

// ✅ Define gradient once for reuse across all tiles in this screen
const _purpleBlueGradient = LinearGradient(
  colors: [
    Color(0xFF9B27AF), // Purple
    Color(0xFF3F51B5), // Blue
  ],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: SafeArea(
        child: Column(
          children: [
            // Header wrapped in Stack for Guidance Manager button
            Stack(
              children: [
                ElevateHeader(
                  title: "Test Your Skills",
                  subTitle: "Test smarter, grow faster, achieve more.",
                ),
                Positioned(
                  top: 60,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Navigate to Guidance Manager screen
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),

                      child: const Text(
                        "Guidance Manager",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search Skill",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            // Skill Tiles List
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
                        gradient: _purpleBlueGradient, // ✅
                      ),
                      const SizedBox(height: 16),
                      SkillTestTile(
                        title: 'Python Development',
                        subtitle: 'Readability and Simplicity',
                        buttonText: 'START',
                        imagePath: 'lib/Resources/Images/java.png',
                        onTap: () {},
                        gradient: _purpleBlueGradient, // ✅
                      ),
                      const SizedBox(height: 16),
                      SkillTestTile(
                        title: 'C++ Development',
                        subtitle: 'High-performance',
                        buttonText: 'START',
                        imagePath: 'lib/Resources/Images/chash.png',
                        onTap: () {},
                        gradient: _purpleBlueGradient, // ✅
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
