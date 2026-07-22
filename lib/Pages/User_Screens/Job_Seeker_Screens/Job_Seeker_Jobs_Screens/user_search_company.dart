import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/short_description_round_circle_icon_tile.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/user_check_company_profile.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSearchCompany extends ConsumerStatefulWidget {
  const UserSearchCompany({super.key});

  @override
  ConsumerState<UserSearchCompany> createState() => _UserSearchCompanyState();
}

class _UserSearchCompanyState extends ConsumerState<UserSearchCompany> {
  final _firebaseService = FirebaseService();
  List<CompanyModel> _allCompanies = [];
  List<CompanyModel> _filteredCompanies = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

  Future<void> _fetchCompanies() async {
    setState(() => _isLoading = true);
    try {
      final list = await _firebaseService.listAllCompanies();
      setState(() {
        _allCompanies = list;
        _filteredCompanies = list;
      });
    } catch (_) {
      // Ignore
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredCompanies = _allCompanies;
      } else {
        _filteredCompanies = _allCompanies
            .where((c) =>
                c.companyName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TexxtButton(
              text: "Back",
              width: 120,
              height: 50,
              textSize: 12,
              textWeight: FontWeight.w500,
              textColor: const Color.fromARGB(255, 255, 255, 255),
              backgroundColor: const Color.fromARGB(224, 114, 114, 114),
              borderColor: const Color(0xFF8B8B8B),
              borderRadius: 80,
              borderWidth: 1,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconText(
                text: "Explore Companies",
                iconData: Icons.people_alt_outlined,
                textWeight: FontWeight.w600,
                iconSize: 25,
                textSize: 17,
              ),
              const SizedBox(height: 25),
              CustomSearchBar(
                hintText: "Search company...",
                backgroundColor: ElevateColor.white,
                width: 330,
                height: 50,
                textSize: 15,
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 15),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      )
                    : _filteredCompanies.isEmpty
                        ? const Center(
                            child: Text(
                              "No companies found",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _filteredCompanies.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 5),
                            itemBuilder: (context, i) {
                              final company = _filteredCompanies[i];
                              final logoUrl = company.logo.isNotEmpty
                                  ? company.logo
                                  : 'https://mir-s3-cdn-cf.behance.net/projects/404/e87f90243740647.Y3JvcCwxNTM0LDEyMDAsMzQsMA.jpg';

                              return ShortDescriptionRoundCircleIconTile(
                                height: 80,
                                width: 330,
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
                                circleSize: 50,
                                circleColor: ElevateColor.lightgray,
                                borderWidth: 2,
                                borderColor: ElevateColor.lightgray,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserCheckCompanyProfile(
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
    );
  }
}
