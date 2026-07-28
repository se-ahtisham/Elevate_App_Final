import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/employee_request_tile.dart';
import 'package:elevate_app/Database/Online_Database/auth_service.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class CompanyFollowRequests extends StatefulWidget {
  const CompanyFollowRequests({super.key});

  @override
  State<CompanyFollowRequests> createState() => _CompanyFollowRequestsState();
}

class _CompanyFollowRequestsState extends State<CompanyFollowRequests> {
  final _firebaseService = FirebaseService();
  final _authService = AuthService();
  final _searchController = TextEditingController();

  List<Map<String, String>> _allRequests = [];
  List<Map<String, String>> _visibleRequests = [];
  bool _isLoading = true;

  // Tracks requestIDs currently being accepted/rejected
  final Set<String> _processingIDs = {};

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRequests() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final myID = _authService.currentUser?.uid;
    if (myID == null) {
      if (!mounted) return;
      setState(() {
        _allRequests = [];
        _visibleRequests = [];
        _isLoading = false;
      });
      return;
    }

    try {
      final fetched = await _firebaseService.getFollowRequestsForCompany(myID);
      if (!mounted) return;
      setState(() {
        _allRequests = fetched;
        _visibleRequests = _applySearch();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("loadRequests for company failed: $e");
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  List<Map<String, String>> _applySearch() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _allRequests;
    return _allRequests
        .where((r) => (r['name'] ?? '').toLowerCase().contains(query))
        .toList();
  }

  void _onSearchChanged(String query) {
    setState(() => _visibleRequests = _applySearch());
  }

  Future<void> _respond(String requestID, bool accept) async {
    setState(() => _processingIDs.add(requestID));

    try {
      if (accept) {
        await _firebaseService.acceptFollowRequestForJobSeeker(requestID, toCollection: 'companies');
      } else {
        await _firebaseService.rejectFollowRequestForJobSeeker(requestID, toCollection: 'companies');
      }
      if (!mounted) return;
      setState(() {
        _allRequests.removeWhere((r) => r['requestID'] == requestID);
        _visibleRequests.removeWhere((r) => r['requestID'] == requestID);
        _processingIDs.remove(requestID);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(accept ? "Follow request accepted" : "Follow request rejected"),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _processingIDs.remove(requestID));
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
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      )
                    : _visibleRequests.isEmpty
                        ? Center(
                            child: CustomText(
                              text: _allRequests.isEmpty
                                  ? "No follow requests right now."
                                  : "No results found.",
                              fontSize: 14,
                              color: ElevateColor.gray,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadRequests,
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: _visibleRequests.length,
                              itemBuilder: (context, index) {
                                final r = _visibleRequests[index];
                                final requestID = r['requestID']!;
                                final isBusy = _processingIDs.contains(requestID);

                                return EmployeeRequestTile(
                                  key: ValueKey(requestID),
                                  height: 120,
                                  width: 330,
                                  backgroundColor: ElevateColor.white,
                                  borderRadius: 20,
                                  imageURL: (r['imageURL'] ?? '').isNotEmpty
                                      ? r['imageURL']!
                                      : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(r['name'] ?? "User")}&background=random&color=fff&size=128&bold=true',
                                  name: r['name'] ?? '',
                                  shortDescription: r['shortDescription'] ?? '',
                                  acceptonTap: isBusy
                                      ? null
                                      : () => _respond(requestID, true),
                                  rejectonTap: isBusy
                                      ? null
                                      : () => _respond(requestID, false),
                                );
                              },
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
