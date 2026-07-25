// lib/Pages/User_Screens/Admin_Screens/admin_api_status_screen.dart

import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api_status_service.dart';

class AdminApiStatusScreen extends StatefulWidget {
  const AdminApiStatusScreen({super.key});

  @override
  State<AdminApiStatusScreen> createState() => _AdminApiStatusScreenState();
}

class _AdminApiStatusScreenState extends State<AdminApiStatusScreen> {
  bool _isLoading = false;
  List<ApiEndpointStatus> _statusList = [];

  @override
  void initState() {
    super.initState();
    _runDiagnostics();
  }

  Future<void> _runDiagnostics() async {
    setState(() => _isLoading = true);
    final results = await ApiStatusChecker.checkAllEndpoints();
    setState(() {
      _statusList = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final liveItems = _statusList
        .where((item) => item.environment == 'Live (Render)')
        .toList();
    final localItems = _statusList
        .where((item) => item.environment == 'Local Machine')
        .toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 243),
        body: Column(
          children: [
            // Custom Brand Header
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
                child: _isLoading
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.black),
                            SizedBox(height: 16),
                            CustomText(
                              text: "Checking System Endpoints...",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _runDiagnostics,
                        color: Colors.black,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),

                              // Overall summary bar
                              _buildSummaryBar(),

                              const SizedBox(height: 20),

                              // Section 1: Live Render Server
                              _buildSectionHeader(
                                "LIVE PRODUCTION SERVER (RENDER)",
                                liveItems,
                              ),
                              const SizedBox(height: 12),
                              ...liveItems.map(
                                (item) => _buildApiEndpointCard(item),
                              ),

                              const SizedBox(height: 25),

                              // Section 2: Local Server
                              _buildSectionHeader(
                                "LOCAL DEVELOPMENT SERVER",
                                localItems,
                              ),
                              const SizedBox(height: 12),
                              ...localItems.map(
                                (item) => _buildApiEndpointCard(item),
                              ),

                              const SizedBox(height: 25),

                              // Re-run Refresh Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _runDiagnostics,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: const CustomText(
                                    text: "RUN DIAGNOSTICS AGAIN",
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Top banner: "X / Y Endpoints Online" across the whole diagnostic run
  Widget _buildSummaryBar() {
    final total = _statusList.length;
    final online = _statusList.where((item) => item.isRunning).length;
    final allOnline = total > 0 && online == total;
    final color = allOnline
        ? Colors.green
        : (online == 0 ? Colors.red : Colors.orange);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: allOnline
                ? "All Systems Operational"
                : "$online of $total Endpoints Online",
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

  // Section header showing environment name + how many of its endpoints are online
  Widget _buildSectionHeader(String title, List<ApiEndpointStatus> items) {
    final total = items.length;
    final online = items.where((item) => item.isRunning).length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        CustomText(
          text: "$online/$total",
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: online == total && total > 0
              ? Colors.green
              : Colors.grey.shade700,
        ),
      ],
    );
  }

  // White Card with full details view
  Widget _buildApiEndpointCard(ApiEndpointStatus status) {
    final bool isOnline = status.isRunning;
    final Color badgeColor = isOnline ? Colors.green : Colors.red;

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
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Endpoint Title + Status Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  text: "[${status.method}] ${status.name}",
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
                  color: badgeColor.withOpacity(0.1),
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

          // Row 2: Target URL
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

          // Row 3: Full Un-truncated Response / Error Details
          if (status.responseMessage != null &&
              status.responseMessage!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const CustomText(
              text: "Response Body:",
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isOnline
                    ? const Color.fromARGB(255, 245, 247, 250)
                    : const Color.fromARGB(255, 255, 235, 235),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isOnline ? Colors.grey.shade300 : Colors.red.shade200,
                ),
              ),
              child: SelectableText(
                status.responseMessage!,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: isOnline ? Colors.black : Colors.red.shade900,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
