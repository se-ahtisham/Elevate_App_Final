import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/admin_portfolio_tile.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/project_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Portfolio/admin_delete_portfolio.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminSearchPortfolio extends StatefulWidget {
  const AdminSearchPortfolio({super.key});

  @override
  State<AdminSearchPortfolio> createState() => AdminSearchPortfolioState();
}

class AdminSearchPortfolioState extends State<AdminSearchPortfolio> {
  final FirebaseService service = FirebaseService();
  final TextEditingController searchController = TextEditingController();

  List<ProjectModel> allProjects = [];
  List<ProjectModel> filteredProjects = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadProjects();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadProjects() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final fetched = await service.listAllProjects();
      final seen = <String>{};
      final unique = fetched.where((p) => seen.add(p.projectID)).toList();
      
      setState(() {
        allProjects = unique;
        filteredProjects = unique;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Failed to load portfolios: $e";
        isLoading = false;
      });
    }
  }

  void onSearchChanged() {
    final query = searchController.text.trim().toLowerCase();
    setState(() {
      filteredProjects = query.isEmpty
          ? allProjects
          : allProjects
                .where((p) => p.projectTitle.toLowerCase().contains(query))
                .toList();
    });
  }

  void openProject(ProjectModel project) async {
    final deleted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AdminDeletePortfolio(project: project)),
    );
    // If it was deleted on the next screen, refresh the list here too.
    if (deleted == true) {
      loadProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 32;

    return Scaffold(
      backgroundColor: ElevateColor.white,
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            ElevateHeader(
              title: "Manage",
              subTitle: "Job Seeker",
              titleSize: 35,
              subtitleSize: 20,
              showBackButton: true,
            ),
            Expanded(
              child: Container(
                color: ElevateColor.white,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.hub_outlined,
                          size: 14,
                          color: ElevateColor.gray,
                        ),
                        SizedBox(width: 16),
                        CustomText(
                          text: "Explore Portfolio",
                          fontSize: 20,
                          color: ElevateColor.gray,
                          fontWeight: FontWeight.w700,
                          lineHeight: 1.0,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        color: ElevateColor.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: const Color(0xFFE9E9E9)),
                      ),
                      child: CustomSearchBar(
                        hintText: "Search by project title",
                        iconData: Icons.search_rounded,
                        iconSize: 19,
                        iconColor: ElevateColor.gray,
                        iconTextSpacing: 8,
                        backgroundColor: Colors.transparent,
                        borderRadius: 30,
                        height: 40,
                        width: width,
                        textSize: 12,
                        controller: searchController,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (error != null) {
                            return Center(child: Text(error!));
                          }
                          if (filteredProjects.isEmpty) {
                            return const Center(
                              child: Text("No portfolios found."),
                            );
                          }
                          return ListView.builder(
                            itemCount: filteredProjects.length,
                            itemBuilder: (context, index) {
                              final project = filteredProjects[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: AdminPortfolioTile(
                                  title: project.projectTitle.isNotEmpty
                                      ? project.projectTitle
                                      : "Untitled Project",
                                  onTap: () => openProject(project),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
