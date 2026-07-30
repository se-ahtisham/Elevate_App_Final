// lib/Pages/User_Screens/Admin_Screens/admin_api_status_screen.dart

import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api_status_service.dart';

class AdminApiStatusScreen extends StatefulWidget {
  const AdminApiStatusScreen({super.key});

  @override
  State<AdminApiStatusScreen> createState() => AdminApiStatusScreenState();
}

class AdminApiStatusScreenState extends State<AdminApiStatusScreen> {
  bool isLoading = false;
  List<ApiEndpointStatus> statusList = [];

  @override
  void initState() {
    super.initState();
    runDiagnostics();
  }

  Future<void> runDiagnostics() async {
    setState(() => isLoading = true);
    final results = await ApiStatusChecker.checkAllEndpoints();
    setState(() {
      statusList = results;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 243),
        body: Column(
          children: [
            ElevateHeader(
              title: "API Engine",
              subTitle: "Diagnostics & Health",
              titleSize: 36,
              subtitleSize: 18,
              showBackButton: true,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: isLoading ? loadingView() : resultsView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.black),
          SizedBox(height: 16),
          CustomText(
            text: "Checking Model Health...",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget resultsView() {
    return RefreshIndicator(
      onRefresh: runDiagnostics,
      color: Colors.black,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            summaryBar(),
            const SizedBox(height: 20),
            ...statusList.map(modelCard),
            const SizedBox(height: 12),
            rerunButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget summaryBar() {
    final total = statusList.length;
    final online = statusList.where((item) => item.isRunning).length;
    final allOnline = total > 0 && online == total;
    final color = allOnline
        ? Colors.green
        : (online == 0 ? Colors.red : Colors.orange);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: allOnline
                ? "All Models Operational"
                : "$online of $total Models Online",
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
            textAlign: TextAlign.left,
          ),
          Icon(
            allOnline ? Icons.check_circle : Icons.warning_amber_rounded,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget rerunButton() {
    return TextButtonGradient(
      text: "REFRESH",
      textSize: 15,
      textWeight: FontWeight.w500,
      width: double.infinity,
      height: 50,
      borderRadius: 50,
      onTap: runDiagnostics,
    );
  }

  Widget modelCard(ApiEndpointStatus status) {
    final isOnline = status.isRunning;
    final badgeColor = isOnline ? Colors.green : Colors.red;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  text: status.name,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  border: Border.all(color: badgeColor, width: 1.5),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: CustomText(
                  text: isOnline
                      ? "ONLINE (${status.statusCode})"
                      : "OFFLINE (${status.statusCode})",
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: badgeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 250, 250, 250),
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomText(
              text: status.url,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
              textAlign: TextAlign.left,
            ),
          ),
          if (!isOnline && status.message != null) ...[
            const SizedBox(height: 10),
            CustomText(
              text: status.message!,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.red.shade400,
              textAlign: TextAlign.left,
            ),
          ],
        ],
      ),
    );
  }
}
