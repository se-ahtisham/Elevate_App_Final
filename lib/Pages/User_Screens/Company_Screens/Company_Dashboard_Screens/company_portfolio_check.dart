import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/project_model.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_seeker_portfolio_tile.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/company_portfolio_check_des.dart';
import 'package:flutter/material.dart';

class CompanyPortfolioCheck extends StatefulWidget {
  final String jobSeekerID;
  const CompanyPortfolioCheck({super.key, required this.jobSeekerID});

  @override
  State<CompanyPortfolioCheck> createState() =>
      _CompanyPortfolioCheckState();
}

class _CompanyPortfolioCheckState extends State<CompanyPortfolioCheck> {
  int currentIndex = 0;
  final ScrollController _scrollController = ScrollController();
  List<ProjectModel> portfolioList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPortfolio();

    _scrollController.addListener(() {
      if (portfolioList.isEmpty) return;
      double offset = _scrollController.offset;
      double itemHeight = 180;
      int newIndex = (offset / itemHeight).round();

      if (newIndex != currentIndex &&
          newIndex >= 0 &&
          newIndex < portfolioList.length) {
        setState(() {
          currentIndex = newIndex;
        });
      }
    });
  }

  Future<void> _fetchPortfolio() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('projects')
          .where('jobSeekerID', isEqualTo: widget.jobSeekerID)
          .get();
      
      final projects = snap.docs.map((doc) => ProjectModel.fromMap(doc.data())).toList();
      setState(() {
        portfolioList = projects;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ElevateHeader(
              title: "PORTFOLIO",
              subTitle: "Showcasing technical abilities",
              showBackButton: true,
            ),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : portfolioList.isEmpty
                      ? const Center(child: Text("No projects found."))
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
                                    builder: (_) => CompanyPortfolioCheckDes(project: project),
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

