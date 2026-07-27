// This screen is a legacy stub. Posts are handled by CompanyViewUserPost.
// Redirect to CompanyViewUserPost with the authorID.
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/company_view_user_post.dart';
import 'package:flutter/material.dart';

class ComapnyViewSearchUserPost extends StatelessWidget {
  final String authorID;

  const ComapnyViewSearchUserPost({super.key, required this.authorID});

  @override
  Widget build(BuildContext context) {
    return CompanyViewUserPost(authorID: authorID);
  }
}
