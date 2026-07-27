// Legacy screen stub delegating to CompanyPortfolioCheck.
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/company_portfolio_check.dart';
import 'package:flutter/material.dart';

class PortfolioScreen extends StatelessWidget {
  final String? jobSeekerID;

  const PortfolioScreen({super.key, this.jobSeekerID});

  @override
  Widget build(BuildContext context) {
    return CompanyPortfolioCheck(jobSeekerID: jobSeekerID ?? '');
  }
}
