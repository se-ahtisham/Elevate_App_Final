import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/white_black_user.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Community_Screens/community_view_company_profile.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Community_Screens/community_view_jobseeker_profile.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Community_Screens/user_community_screen.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BrowseFilter { all, jobSeekers, companies }

class CommunitySearch extends ConsumerStatefulWidget {
  const CommunitySearch({super.key});

  @override
  ConsumerState<CommunitySearch> createState() => CommunitySearchState();
}

class CommunitySearchState extends ConsumerState<CommunitySearch> {
  final firebaseService = FirebaseService();
  final searchController = TextEditingController();

  List<Map<String, String>> allResults = [];
  List<Map<String, String>> visibleResults = [];
  BrowseFilter activeFilter = BrowseFilter.all;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Map<String, String> seekerToMap(JobSeekerModel seeker) {
    return {
      'id': seeker.jobSeekerID,
      'name': seeker.name,
      'subtitle': seeker.experienceLevel.isNotEmpty
          ? seeker.experienceLevel
          : 'Job Seeker',
      'imageUrl': seeker.profilePic.isNotEmpty
          ? seeker.profilePic
          : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(seeker.name.isNotEmpty ? seeker.name : "User")}&background=E0E0E0&color=757575&size=128&bold=true',
      'type': 'JobSeeker',
    };
  }

  Map<String, String> companyToMap(CompanyModel company) {
    return {
      'id': company.companyID,
      'name': company.companyName,
      'subtitle': company.industry.isNotEmpty ? company.industry : 'Company',
      'imageUrl': company.logo.isNotEmpty
          ? company.logo
          : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(company.companyName.isNotEmpty ? company.companyName : "Company")}&background=E0E0E0&color=757575&size=128&bold=true',
      'type': 'Company',
    };
  }

  Future<void> loadResults() async {
    setState(() => isLoading = true);

    final myID = ref.read(authProvider).jobSeeker?.jobSeekerID;
    final seekers = await firebaseService.listAllJobSeekers();
    final companies = await firebaseService.listAllCompanies();

    allResults = [
      ...seekers.where((s) => s.jobSeekerID != myID).map(seekerToMap),
      ...companies.map(companyToMap),
    ];

    setState(() {
      visibleResults = applyFilterAndSearch();
      isLoading = false;
    });
  }

  List<Map<String, String>> applyFilterAndSearch() {
    List<Map<String, String>> results = allResults;

    if (activeFilter == BrowseFilter.jobSeekers) {
      results = results.where((m) => m['type'] == 'JobSeeker').toList();
    } else if (activeFilter == BrowseFilter.companies) {
      results = results.where((m) => m['type'] == 'Company').toList();
    }

    final query = searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      results = results
          .where((m) => (m['name'] ?? '').toLowerCase().contains(query))
          .toList();
    }

    return results;
  }

  void onSearchChanged(String query) {
    setState(() => visibleResults = applyFilterAndSearch());
  }

  void setFilter(BrowseFilter filter) {
    setState(() {
      activeFilter = filter;
      visibleResults = applyFilterAndSearch();
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
    ).then((value) => loadResults());
  }

  void openCommunityCenter() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserCommunityScreen()),
    );
  }

  Widget filterChip(String label, BrowseFilter filter) {
    final isActive = activeFilter == filter;

    return GestureDetector(
      onTap: () => setFilter(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : ElevateColor.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive ? Colors.black : ElevateColor.gray,
          ),
        ),
        child: CustomText(
          text: label,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isActive ? ElevateColor.white : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF3F3F3),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            Stack(
              children: [
                ElevateHeader(
                  title: "Discover",
                  subTitle: "Your Network",
                  titleSize: 40,
                  subtitleSize: 25,
                ),
                Positioned(
                  top: 170,
                  right: 120,
                  child: TexxtButton(
                    text: "Community",
                    width: 130,
                    height: 50,
                    textSize: 12,
                    textWeight: FontWeight.w500,
                    textColor: const Color.fromARGB(255, 46, 46, 46),
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    borderColor: const Color(0xFF8B8B8B),
                    borderRadius: 80,
                    borderWidth: 1,
                    onTap: openCommunityCenter,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const IconText(
                      text: "Explore Profiles",
                      iconData: Icons.people_alt_outlined,
                      textSize: 20,
                      textWeight: FontWeight.bold,
                      iconSize: 25,
                      iconTextSpacing: 10,
                    ),
                    const SizedBox(height: 15),
                    CustomSearchBar(
                      hintText: "Search people & companies",
                      backgroundColor: ElevateColor.white,
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
                        filterChip("All", BrowseFilter.all),
                        const SizedBox(width: 10),
                        filterChip("Job Seekers", BrowseFilter.jobSeekers),
                        const SizedBox(width: 10),
                        filterChip("Companies", BrowseFilter.companies),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                      )
                    else if (visibleResults.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: CustomText(
                            text: "No results found.",
                            fontSize: 15,
                            color: ElevateColor.gray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      Column(
                        children: visibleResults.map((member) {
                          final imageUrl = member['imageUrl'] ?? '';
                          return Padding(
                            key: ValueKey(member['id']),
                            padding: const EdgeInsets.only(bottom: 10),
                            child: WhiteBlackUser(
                              imageURL: imageUrl,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
