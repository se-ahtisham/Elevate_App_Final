import 'package:cloud_firestore/cloud_firestore.dart';
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
  int portfolioCount = 0;
  int communityPostCount = 0;

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
      ]);

      // Extra counts via Firestore directly
      final postsSnap = await FirebaseFirestore.instance.collection('posts').get();
      final projectsSnap = await FirebaseFirestore.instance.collection('projects').get();

      if (!mounted) return;
      setState(() {
        jobSeekerCount = results[0].length;
        companyCount = results[1].length;
        skillCount = results[2].length;
        jobCount = results[3].length;
        postCount = postsSnap.docs.length;
        portfolioCount = projectsSnap.docs.length;
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
              title: "Admin Dashboard",
              subTitle: "App Performance Metrics",
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
                    text: "Live Statistics Overview",
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
                                bottomText: "Job Posts",
                                count: jobCount,
                              ),
                              const SizedBox(height: 20),
                              AdminCard(
                                topText: "Total",
                                bottomText: "Community Posts",
                                count: postCount,
                              ),
                              const SizedBox(height: 20),
                              AdminCard(
                                topText: "Total",
                                bottomText: "Portfolio Projects",
                                count: portfolioCount,
                              ),
                              const SizedBox(height: 30),
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
