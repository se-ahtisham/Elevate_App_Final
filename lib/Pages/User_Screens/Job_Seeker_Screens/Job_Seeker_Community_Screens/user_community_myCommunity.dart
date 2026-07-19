import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/white_black_user.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Community_Screens/community_view_jobseeker_profile.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Community_Screens/community_view_company_profile.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CommunityFilter { all, jobSeekers, companies }

class UserCommunityMycommunityScreen extends ConsumerStatefulWidget {
  const UserCommunityMycommunityScreen({super.key});

  @override
  ConsumerState<UserCommunityMycommunityScreen> createState() =>
      UserCommunityMycommunityScreenState();
}

class UserCommunityMycommunityScreenState
    extends ConsumerState<UserCommunityMycommunityScreen> {
  final firebaseService = FirebaseService();
  final searchController = TextEditingController();

  List<Map<String, String>> allMembers = [];
  List<Map<String, String>> visibleMembers = [];
  CommunityFilter activeFilter = CommunityFilter.all;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCommunity();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadCommunity() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final myID = ref.read(authProvider).jobSeeker?.jobSeekerID;
    if (myID == null) {
      if (!mounted) return;
      setState(() {
        allMembers = [];
        visibleMembers = [];
        isLoading = false;
      });
      return;
    }

    allMembers = await firebaseService.getMyCommunity(myID);

    if (!mounted) return;
    setState(() {
      visibleMembers = applyFilterAndSearch();
      isLoading = false;
    });
  }

  List<Map<String, String>> applyFilterAndSearch() {
    List<Map<String, String>> members = allMembers;

    if (activeFilter == CommunityFilter.jobSeekers) {
      members = members.where((m) => m['type'] == 'JobSeeker').toList();
    } else if (activeFilter == CommunityFilter.companies) {
      members = members.where((m) => m['type'] == 'Company').toList();
    }

    final query = searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      members = members
          .where((m) => (m['name'] ?? '').toLowerCase().contains(query))
          .toList();
    }

    return members;
  }

  void onSearchChanged(String query) {
    setState(() => visibleMembers = applyFilterAndSearch());
  }

  void setFilter(CommunityFilter filter) {
    setState(() {
      activeFilter = filter;
      visibleMembers = applyFilterAndSearch();
    });
  }

  void openProfile(Map<String, String> member) {
    final isCompany = member['type'] == 'Company';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => isCompany
            ? CommunityViewCompanyProfile(companyID: member['id']!)
            : CommunityViewJobseekerProfile(jobSeekerID: member['id']!),
      ),
    ).then((value) => loadCommunity());
  }

  Widget filterChip(String label, CommunityFilter filter) {
    final isActive = activeFilter == filter;

    return GestureDetector(
      onTap: () => setFilter(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive ? Colors.black : ElevateColor.gray,
          ),
        ),
        child: CustomText(
          text: label,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSearchBar(
          hintText: "Search Followers",
          backgroundColor: const Color.fromARGB(255, 235, 235, 235),
          width: 380,
          height: 60,
          textSize: 15,
          iconSize: 30,
          controller: searchController,
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 15),

        Row(
          children: [
            filterChip("All", CommunityFilter.all),
            const SizedBox(width: 10),
            filterChip("Job Seekers", CommunityFilter.jobSeekers),
            const SizedBox(width: 10),
            filterChip("Companies", CommunityFilter.companies),
          ],
        ),
        const SizedBox(height: 20),

        Expanded(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                )
              : visibleMembers.isEmpty
              ? const Center(
                  child: CustomText(
                    text: "No connections yet.",
                    fontSize: 15,
                    color: ElevateColor.gray,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: visibleMembers.map((member) {
                      final imageUrl = member['imageUrl'] ?? '';
                      return Padding(
                        key: ValueKey(member['id']),
                        padding: const EdgeInsets.only(bottom: 10),
                        child: WhiteBlackUser(
                          imageURL: imageUrl.isNotEmpty
                              ? imageUrl
                              : "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                          name: member['name'] ?? '',
                          shortDescription: member['subtitle'] ?? '',
                          experience: member['type'] ?? '',
                          firstContainerWidth: 270,
                          experienceBoxWidth: 240,
                          tileHeight: 80,
                          onTap: () => openProfile(member),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ),
      ],
    );
  }
}
