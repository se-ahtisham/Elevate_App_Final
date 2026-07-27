// This screen is a legacy stub. Messaging is now handled by CompanyMessageScreen.
// This file is kept only for backward compatibility but redirects immediately.
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Dashboard_Screens/company_message_screen.dart';
import 'package:flutter/material.dart';

class ComapanyUserMessage extends StatelessWidget {
  final String receiverId;
  final String receiverName;
  final String receiverImage;

  const ComapanyUserMessage({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
  });

  @override
  Widget build(BuildContext context) {
    return CompanyMessageScreen(
      receiverId: receiverId,
      receiverName: receiverName,
      receiverImage: receiverImage,
    );
  }
}
