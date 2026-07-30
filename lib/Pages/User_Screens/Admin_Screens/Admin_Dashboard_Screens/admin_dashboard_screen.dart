import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/admin_card.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final FirebaseService firebaseService = FirebaseService();

  int jobSeekerCount = 0;
  int companyCount = 0;
  int skillCount = 0;
  int jobCount = 0;
  int postCount = 0;
  int badgeCount = 0;
  int portfolioCount = 0;
  int testCount = 0;
  int applicationCount = 0;
  int reviewCount = 0;
  int employeeCount = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCounts();
  }

  Future<void> loadCounts() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final results = await Future.wait([
        firebaseService.listAllJobSeekers(),
        firebaseService.listAllCompanies(),
        firebaseService.listAllSkills(),
        firebaseService.viewAllJobs(),
        firebaseService.listAllPosts(),
        firebaseService.listAllBadges(),
        firebaseService.listAllProjects(),
        firebaseService.viewAllSkillTests(),
        firebaseService.listAllApplications(),
        firebaseService.listAllReviews(),
        firebaseService.listAllEmployees(),
      ]);

      if (!mounted) return;
      setState(() {
        jobSeekerCount = results[0].length;
        companyCount = results[1].length;
        skillCount = results[2].length;
        jobCount = results[3].length;
        postCount = results[4].length;
        badgeCount = results[5].length;
        portfolioCount = results[6].length;
        testCount = results[7].length;
        applicationCount = results[8].length;
        reviewCount = results[9].length;
        employeeCount = results[10].length;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Couldn't load dashboard stats. Pull to retry."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ElevateHeader(
              title: "Ahtisham Dashboard",
              subTitle: "Check the Statictics",
            ),

            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 40, bottom: 20),
              child: Container(
                height: 50,
                width: 370,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.black),
                  ),
                ),
                child: const Center(
                  child: CustomText(
                    text: "App Performance Metrics",
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    )
                  : RefreshIndicator(
                      onRefresh: loadCounts,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              AdminCard(
                                topText: "Total",
                                bottomText: "Job Seekers",
                                count: jobSeekerCount,
                              ),
                              const SizedBox(height: 20),
                              AdminCard(
                                topText: "Total",
                                bottomText: "Companies",
                                count: companyCount,
                              ),
                              const SizedBox(height: 20),
                              AdminCard(
                                topText: "Total",
                                bottomText: "Skills",
                                count: skillCount,
                              ),
                              const SizedBox(height: 20),
                              AdminCard(
                                topText: "Total",
                                bottomText: "Jobs",
                                count: jobCount,
                              ),
                              const SizedBox(height: 20),
                              AdminCard(
                                topText: "Total",
                                bottomText: "Posts",
                                count: postCount,
                              ),
                              const SizedBox(height: 20),
                              AdminCard(
                                topText: "Total",
                                bottomText: "Badges",
                                count: badgeCount,
                              ),
                              const SizedBox(height: 20),
                              AdminCard(
                                topText: "Total",
                                bottomText: "Portfolios",
                                count: portfolioCount,
                              ),
                              const SizedBox(height: 20),
                              AdminCard(
                                topText: "Total",
                                bottomText: "Tests",
                                count: testCount,
                              ),
                              const SizedBox(height: 20),
                              AdminCard(
                                topText: "Total",
                                bottomText: "Applications",
                                count: applicationCount,
                              ),
                              const SizedBox(height: 20),
                              AdminCard(
                                topText: "Total",
                                bottomText: "Reviews",
                                count: reviewCount,
                              ),
                              const SizedBox(height: 20),
                              AdminCard(
                                topText: "Total",
                                bottomText: "Employees",
                                count: employeeCount,
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
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
