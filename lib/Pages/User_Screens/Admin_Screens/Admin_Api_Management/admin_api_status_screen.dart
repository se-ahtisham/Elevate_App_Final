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

                              // Section 1: Live Render Server
                              const CustomText(
                                text: "LIVE PRODUCTION SERVER (RENDER)",
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 12),
                              ..._statusList
                                  .where(
                                    (item) =>
                                        item.environment == 'Live (Render)',
                                  )
                                  .map((item) => _buildApiEndpointCard(item)),

                              const SizedBox(height: 25),

                              // Section 2: Local Server
                              const CustomText(
                                text: "LOCAL DEVELOPMENT SERVER",
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 12),
                              ..._statusList
                                  .where(
                                    (item) =>
                                        item.environment == 'Local Machine',
                                  )
                                  .map((item) => _buildApiEndpointCard(item)),

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
          )
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
                      ? "ONLINE (200)"
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
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
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