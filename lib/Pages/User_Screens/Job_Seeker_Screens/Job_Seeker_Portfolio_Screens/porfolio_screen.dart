import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/project_model.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Portfolio_Screens/job_seeker_portfolio_description_screen.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Portfolio_Screens/new_portfolio_Screen.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_seeker_portfolio_tile.dart';

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

    // If we're viewing our own portfolio and auth hasn't finished loading
    // the job seeker yet, effectiveJobSeekerID will be '' on first build.
    // Re-load automatically once the job seeker becomes available so we
    // don't get stuck showing "No projects yet" for a user who has projects.
    if (isOwnPortfolio) {
      ref.listenManual(authProvider, (previous, next) {
        final wasMissing = previous?.jobSeeker?.jobSeekerID == null;
        final nowPresent = next.jobSeeker?.jobSeekerID != null;
        if (wasMissing && nowPresent) {
          loadProjects();
        }
      });
    }
  }

  Future<void> loadProjects() async {
    if (!mounted) return;
    if (effectiveJobSeekerID.isEmpty) {
      // Auth hasn't resolved a job seeker yet; nothing to fetch.
      setState(() {
        projects = [];
        isLoading = false;
      });
      return;
    }

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                ElevateHeader(
                  title: isOwnPortfolio ? "MY PORTFOLIO" : "PORTFOLIO",
                  subTitle: "Proven technical abilities",
                  titleSize: 25,
                  subtitleSize: 15,
                ),

                // Back button for viewing others' portfolios
                if (!isOwnPortfolio)
                  Positioned(
                    top: 60,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
                        await Navigator.of(context, rootNavigator: true).push(
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
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.work_outline,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          const CustomText(
                            text: "No projects yet",
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: ElevateColor.gray,
                          ),
                          if (isOwnPortfolio) ...[
                            const SizedBox(height: 4),
                            const CustomText(
                              text: "Tap 'New Project' to add your work",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: ElevateColor.gray,
                            ),
                          ],
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      itemCount: projects.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final project = projects[index];
                        return JobSeekerPortfolioTile(
                          project: project,
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        JobSeekerPortfolioDescriptionScreen(
                                          project: project,
                                        ),
                                  ),
                                )
                                .then(
                                  (_) => isOwnPortfolio ? loadProjects() : null,
                                );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
