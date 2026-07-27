// Legacy screen stub delegating to CompanyPortfolioCheckDes.
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/project_model.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/company_portfolio_check_des.dart';
import 'package:flutter/material.dart';

class PortfolioDescriptionScreen extends StatelessWidget {
  final ProjectModel? project;

  const PortfolioDescriptionScreen({super.key, this.project});

  @override
  Widget build(BuildContext context) {
    if (project != null) {
      return CompanyPortfolioCheckDes(project: project!);
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Project Details")),
      body: const Center(child: Text("No project data provided.")),
    );
  }
}
