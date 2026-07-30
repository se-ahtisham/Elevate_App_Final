import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_seeker_portfolio_tile.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/project_model.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/company_portfolio_check_des.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class CompanyPortfolioCheck extends StatefulWidget {
  final String jobSeekerID;
  const CompanyPortfolioCheck({super.key, required this.jobSeekerID});

  @override
  State<CompanyPortfolioCheck> createState() => _CompanyPortfolioCheckState();
}

class _CompanyPortfolioCheckState extends State<CompanyPortfolioCheck> {
  final firebaseService = FirebaseService();

  List<ProjectModel> portfolioList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPortfolio();
  }

  Future<void> _fetchPortfolio() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    // Use the shared service method instead of querying Firestore
    // directly, matching PorfolioScreen and the rest of the codebase.
    final projects = await firebaseService.getProjectsForJobSeeker(
      widget.jobSeekerID,
    );

    if (!mounted) return;
    setState(() {
      portfolioList = projects;
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
                const ElevateHeader(
                  title: "PORTFOLIO",
                  subTitle: "Proven technical abilities",
                  titleSize: 25,
                  subtitleSize: 15,
                  showBackButton: false,
                ),

                // Same custom back button used by PorfolioScreen when
                // viewing someone else's portfolio.
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
              ],
            ),

            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    )
                  : portfolioList.isEmpty
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
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      itemCount: portfolioList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final project = portfolioList[index];
                        return JobSeekerPortfolioTile(
                          project: project,
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    CompanyPortfolioCheckDes(project: project),
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
    );
  }
}
