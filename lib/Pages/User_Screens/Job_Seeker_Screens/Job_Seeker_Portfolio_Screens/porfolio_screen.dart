import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/PortfolioCard.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/project_model.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Portfolio_Screens/job_seeker_portfolio_description_screen.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Portfolio_Screens/new_portfolio_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PorfolioScreen extends ConsumerStatefulWidget {
  /// If provided, shows the portfolio of another job seeker (read-only).
  /// If null, shows the current user's own portfolio.
  final String? jobSeekerID;

  const PorfolioScreen({super.key, this.jobSeekerID});

  @override
  ConsumerState<PorfolioScreen> createState() => _PorfolioScreenState();
}

class _PorfolioScreenState extends ConsumerState<PorfolioScreen> {
  final firebaseService = FirebaseService();
  final ScrollController _scrollController = ScrollController();

  List<ProjectModel> projects = [];
  bool isLoading = true;

  String get effectiveJobSeekerID {
    return widget.jobSeekerID ??
        ref.read(authProvider).jobSeeker?.jobSeekerID ??
        '';
  }

  bool get isOwnPortfolio => widget.jobSeekerID == null;

  @override
  void initState() {
    super.initState();
    loadProjects();
  }

  Future<void> loadProjects() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final loaded = await firebaseService.getProjectsForJobSeeker(
      effectiveJobSeekerID,
    );

    if (!mounted) return;
    setState(() {
      projects = loaded;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Stack(
            children: [
              ElevateHeader(
                title: "MY PORTFOLIO",
                subTitle: "Proven technical abilities",
                titleSize: 25,
                subtitleSize: 15,
              ),

              if (isOwnPortfolio)
                Padding(
                  padding: const EdgeInsets.only(left: 220, top: 70),
                  child: TexxtButton(
                    text: "New Project",
                    textSize: 13,
                    textColor: Colors.white,
                    textWeight: FontWeight.w500,
                    backgroundColor: const Color.fromARGB(144, 155, 155, 155),
                    borderRadius: 30,
                    borderWidth: 1,
                    height: 50,
                    width: 150,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewPortfolioScreen(),
                        ),
                      );
                      loadProjects();
                    },
                  ),
                ),
            ],
          ),

          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                : projects.isEmpty
                ? const Center(child: Text("No projects yet."))
                : ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: projects.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      return PortfolioCard(
                        isActive: false,
                        title: project.projectTitle,
                        description: project.projectDescription,
                        role: project.techStack.isNotEmpty
                            ? project.techStack.join(', ')
                            : 'Developer',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  JobSeekerPortfolioDescriptionScreen(
                                    project: project,
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
