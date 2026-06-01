import 'package:elevate_app/Navigations/admin_bottom_navigation.dart';
import 'package:elevate_app/Navigations/job_seeker_bottom_navigation.dart';
import 'package:flutter/material.dart';

class JobSeekerMain extends StatelessWidget {
  String? niche;
  String? experience;

  JobSeekerMain({super.key, required this.niche, required this.experience});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: JobSeekerBottomNavigation(niche: niche!, experience: experience!),
    );
  }
}
