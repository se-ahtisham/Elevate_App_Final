import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/employee_request_tile.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobSeekerFollowRequests extends ConsumerStatefulWidget {
  const JobSeekerFollowRequests({super.key});

  @override
  ConsumerState<JobSeekerFollowRequests> createState() =>
      JobSeekerFollowRequestsState();
}

class JobSeekerFollowRequestsState
    extends ConsumerState<JobSeekerFollowRequests> {
  final firebaseService = FirebaseService();
  final searchController = TextEditingController();

  List<Map<String, String>> allRequests = [];
  List<Map<String, String>> visibleRequests = [];
  bool isLoading = true;

  // Tracks requestIDs currently being accepted/rejected, so each tile can
  // disable its own buttons instead of blocking the whole screen.
  final Set<String> processingIDs = {};

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadRequests() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final myID = ref.read(authProvider).jobSeeker?.jobSeekerID;
    if (myID == null) {
      if (!mounted) return;
      setState(() {
        allRequests = [];
        visibleRequests = [];
        isLoading = false;
      });
      debugPrint(
        "loadRequests: no jobSeekerID on authProvider — user not loaded?",
      );
      return;
    }

    try {
      final fetched = await firebaseService.getFollowRequestsForJobSeeker(myID);
      if (!mounted) return;
      setState(() {
        allRequests = fetched;
        visibleRequests = applySearch();
        isLoading = false;
      });
    } catch (e, stack) {
      debugPrint("loadRequests failed: $e");
      debugPrint("$stack");
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("ERROR: $e")));
    }
  }

  List<Map<String, String>> applySearch() {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) return allRequests;
    return allRequests
        .where((r) => (r['name'] ?? '').toLowerCase().contains(query))
        .toList();
  }

  void onSearchChanged(String query) {
    setState(() => visibleRequests = applySearch());
  }

  Future<void> respond(String requestID, bool accept) async {
    setState(() => processingIDs.add(requestID));

    try {
      if (accept) {
        await firebaseService.acceptFollowRequestForJobSeeker(requestID);
      } else {
        await firebaseService.rejectFollowRequestForJobSeeker(requestID);
      }
      if (!mounted) return;
      setState(() {
        allRequests.removeWhere((r) => r['requestID'] == requestID);
        visibleRequests.removeWhere((r) => r['requestID'] == requestID);
        processingIDs.remove(requestID);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => processingIDs.remove(requestID));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            accept
                ? "Couldn't accept that request. Try again."
                : "Couldn't reject that request. Try again.",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: IconText(
                      text: "Follow Requests",
                      iconData: Icons.people,
                      textWeight: FontWeight.w600,
                      iconSize: 25,
                      textSize: 17,
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButtonGradient(
                    text: "Back",
                    width: 90,
                    height: 40,
                    textSize: 12,
                    textWeight: FontWeight.w500,
                    textColor: Colors.white,
                    borderColor: ElevateColor.gray,
                    borderRadius: 80,
                    borderWidth: 1,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomSearchBar(
                hintText: "Search by name",
                backgroundColor: ElevateColor.white,
                width: 330,
                height: 50,
                textSize: 15,
                controller: searchController,
                onChanged: onSearchChanged,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      )
                    : visibleRequests.isEmpty
                    ? Center(
                        child: CustomText(
                          text: allRequests.isEmpty
                              ? "No follow requests right now."
                              : "No results found.",
                          fontSize: 14,
                          color: ElevateColor.gray,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: loadRequests,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: visibleRequests.map((r) {
                              final requestID = r['requestID']!;
                              final isBusy = processingIDs.contains(requestID);

                              return EmployeeRequestTile(
                                key: ValueKey(requestID),
                                height: 120,
                                width: 330,
                                backgroundColor: ElevateColor.white,
                                borderRadius: 20,
                                imageURL: (r['imageURL'] ?? '').isNotEmpty
                                    ? r['imageURL']!
                                    : 'lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg',
                                name: r['name'] ?? '',
                                shortDescription: r['shortDescription'] ?? '',
                                acceptonTap: isBusy
                                    ? null
                                    : () => respond(requestID, true),
                                rejectonTap: isBusy
                                    ? null
                                    : () => respond(requestID, false),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
