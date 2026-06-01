import 'package:elevate_app/Navigations/company_bottom_navigation.dart';
import 'package:flutter/material.dart';

class CompanyMain extends StatelessWidget {
  const CompanyMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CompanyBottomNavigation(),
      ),
    );
  }
}
