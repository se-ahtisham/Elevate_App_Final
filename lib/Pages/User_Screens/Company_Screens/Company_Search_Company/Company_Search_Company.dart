import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/short_description_round_circle_icon_tile.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Search_Company/Compnay_View_Company_Profile.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class CompanySearchCompany extends StatefulWidget {
  const CompanySearchCompany({super.key});

  @override
  State<CompanySearchCompany> createState() => _CompanySearchCompanyState();
}

class _CompanySearchCompanyState extends State<CompanySearchCompany> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: SafeArea(
        child: Column(
          children: [
            // Full-width header
            ElevateHeader(
              title: "Explore Companies",
              subTitle: "Find companies to follow",
              showBackButton: false,
            ),

            // Rest of the content remains padded
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSearchBar(
                      hintText: "Search companies...",
                      backgroundColor: ElevateColor.white,
                      width: double.infinity,
                      height: 50,
                      textSize: 15,
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() => _query = v),
                    ),

                    const SizedBox(height: 15),

                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('companies')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }

                          final docs = snapshot.data?.docs ?? [];
                          final seen = <String>{};

                          final companies = docs
                              .map((d) {
                                final data = Map<String, dynamic>.from(
                                  d.data() as Map<String, dynamic>,
                                );
                                data['companyID'] = d.id;
                                return CompanyModel.fromMap(data);
                              })
                              .where((c) => seen.add(c.companyID))
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
                              child: Text("No companies found."),
                            );
                          }

                          return ListView.separated(
                            itemCount: companies.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 5),
                            itemBuilder: (context, index) {
                              final company = companies[index];

                              return ShortDescriptionRoundCircleIconTile(
                                height: 80,
                                width: double.infinity,
                                backgroundColor: ElevateColor.white,
                                borderRadius: 20,
                                imageURL: company.logo.isNotEmpty
                                    ? company.logo
                                    : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(company.companyName.isNotEmpty ? company.companyName : "Company")}&background=E0E0E0&color=757575&size=128&bold=true',
                                name: company.companyName,
                                shortDescription: company.industry,
                                iconData: Icons.arrow_forward,
                                iconSize: 24,
                                iconColor: Colors.white,
                                circleSize: 50,
                                circleColor: ElevateColor.lightgray,
                                borderWidth: 2,
                                borderColor: ElevateColor.lightgray,
                                onTap: () {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CompnayViewCompanyProfile(
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
