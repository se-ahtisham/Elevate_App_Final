import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/PortfolioCard.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/project_model.dart';
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
            ),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : portfolioList.isEmpty
                      ? const Center(child: Text("No projects found."))
                      : ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          itemCount: portfolioList.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = portfolioList[index];
                            final bool isActive = currentIndex == index;

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CompanyPortfolioCheckDes(project: item),
                                  ),
                                );
                              },
                              child: AnimatedScale(
                                scale: isActive ? 1.0 : 0.95,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  child: PortfolioCard(
                                    isActive: isActive,
                                    title: item.projectTitle,
                                    description: item.projectDescription,
                                    role: "Developer", // default role as it's not in the model
                                  ),
                                ),
                              ),
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
