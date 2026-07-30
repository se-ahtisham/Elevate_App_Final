import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/short_description_round_circle_icon_tile.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/user_check_company_profile.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSearchCompany extends ConsumerStatefulWidget {
  const UserSearchCompany({super.key});

  @override
  ConsumerState<UserSearchCompany> createState() => UserSearchCompanyState();
}

class UserSearchCompanyState extends ConsumerState<UserSearchCompany> {
  final firebaseService = FirebaseService();
  List<CompanyModel> allCompanies = [];
  List<CompanyModel> filteredCompanies = [];
  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchCompanies();
  }

  Future<void> fetchCompanies() async {
    setState(() => isLoading = true);
    try {
      final list = await firebaseService.listAllCompanies();
      if (!mounted) return;
      setState(() {
        allCompanies = list;
        filteredCompanies = list;
      });
    } catch (_) {
      // Ignore
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void onSearchChanged(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        filteredCompanies = allCompanies;
      } else {
        filteredCompanies = allCompanies
            .where(
              (c) => c.companyName.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            const ElevateHeader(
              title: "Explore Companies",
              subTitle: "Search and discover registered companies",
              titleSize: 28,
              subtitleSize: 14,
              showBackButton: true,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    CustomSearchBar(
                      hintText: "Search company name...",
                      backgroundColor: ElevateColor.white,
                      width: double.infinity,
                      height: 48,
                      textSize: 14,
                      iconSize: 22,
                      controller: searchController,
                      onChanged: onSearchChanged,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : filteredCompanies.isEmpty
                          ? const Center(
                              child: Text(
                                "No companies found",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.only(bottom: 20),
                              itemCount: filteredCompanies.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, i) {
                                final company = filteredCompanies[i];
                                final logoUrl = company.logo.isNotEmpty
                                    ? company.logo
                                    : 'https://mir-s3-cdn-cf.behance.net/projects/404/e87f90243740647.Y3JvcCwxNTM0LDEyMDAsMzQsMA.jpg';

                                return ShortDescriptionRoundCircleIconTile(
                                  height: 80,
                                  width: double.infinity,
                                  backgroundColor: ElevateColor.white,
                                  borderRadius: 20,
                                  imageURL: logoUrl,
                                  name: company.companyName,
                                  shortDescription: company.industry.isNotEmpty
                                      ? company.industry
                                      : 'Company',
                                  iconData: Icons.arrow_forward,
                                  iconSize: 24,
                                  iconColor: Colors.white,
                                  circleSize: 44,
                                  circleColor: ElevateColor.lightgray,
                                  borderWidth: 1,
                                  borderColor: const Color(0xFFE0E0E0),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UserCheckCompanyProfile(
                                              company: company,
                                            ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
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
