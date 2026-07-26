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
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.work_outline, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        const CustomText(
                          text: "No projects yet",
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: ElevateColor.gray,
                        ),
                        const SizedBox(height: 4),
                        const CustomText(
                          text: "Tap 'New Project' to add your work",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: ElevateColor.gray,
                        ),
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
                      final techLabel = project.techStack.isNotEmpty
                          ? project.techStack.join(', ')
                          : 'Developer';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  JobSeekerPortfolioDescriptionScreen(
                                    project: project,
                                  ),
                            ),
                          ).then((_) => loadProjects());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFE0E0E0),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Project icon
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3C3C3C),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.code_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              // Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: project.projectTitle,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 4),
                                    CustomText(
                                      text: project.projectDescription.isNotEmpty
                                          ? project.projectDescription
                                          : "No description",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF3C3C3C),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        techLabel,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Colors.black38,
                                ),
                              ),
                            ],
                          ),
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
