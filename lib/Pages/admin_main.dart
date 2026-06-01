import 'package:elevate_app/Navigations/admin_bottom_navigation.dart';
import 'package:flutter/material.dart';

class AdminMain extends StatelessWidget {
  const AdminMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AdminBottomNavigation(),
      ),
    );
  }
}
