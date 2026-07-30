import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/white_black_user.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
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
  final TextEditingController searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void onSearchChanged(String query) {
    setState(() {
      _query = query;
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
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('companies')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return const Center(
                              child: Text(
                                "Error loading companies",
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }

                          final docs = snapshot.data?.docs ?? [];
                          final seenNames = <String>{};

                          final companies = docs
                              .map((d) {
                                final data = Map<String, dynamic>.from(
                                  d.data() as Map<String, dynamic>,
                                );
                                data['companyID'] = d.id;
                                return CompanyModel.fromMap(data);
                              })
                              .where(
                                (c) =>
                                    seenNames.add(c.companyName.toLowerCase()),
                              )
                              .where((c) {
                                if (_query.trim().isEmpty) return true;

                                final q = _query.toLowerCase();

                                return c.companyName.toLowerCase().contains(
                                      q,
                                    ) ||
                                    c.industry.toLowerCase().contains(q);
                              })
                              .toList();

                          if (companies.isEmpty) {
                            return const Center(
                              child: Text(
                                "No companies found",
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: companies.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final company = companies[i];
                              final logoUrl = company.logo.isNotEmpty
                                  ? company.logo
                                  : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(company.companyName.isNotEmpty ? company.companyName : "Company")}&background=E0E0E0&color=757575&size=128&bold=true';

                              return WhiteBlackUser(
                                tileHeight: 80,
                                firstContainerWidth: 260,
                                experienceBoxWidth: 240,
                                imageURL: logoUrl,
                                name: company.companyName,
                                shortDescription: company.industry.isNotEmpty
                                    ? company.industry
                                    : 'Company',
                                experience: company.location,
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
