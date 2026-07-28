import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
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
                            final techLabel = project.techStack.isNotEmpty
                                ? project.techStack.join(', ')
                                : 'Developer';

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CompanyPortfolioCheckDes(project: project),
                                  ),
                                );
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
      ),
    );
  }
}
