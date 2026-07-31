import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/short_description_round_circle_icon_tile.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Search_users_Screens/company_view_profile.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class CompanySearchUser extends StatefulWidget {
  const CompanySearchUser({super.key});

  @override
  State<CompanySearchUser> createState() => _CompanySearchUserState();
}

class _CompanySearchUserState extends State<CompanySearchUser> {
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
            // Header without padding
            ElevateHeader(
              title: "Job Seeker Profile",
              subTitle: "Explore all job seekers",
              showBackButton: false,
            ),

            // Everything else remains padded
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
                      hintText: "Search job seekers...",
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
                            .collection('jobSeekers')
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
                          final seenNames = <String>{};

                          final seekers = docs
                              .map(
                                (d) => JobSeekerModel.fromMap(
                                  d.data() as Map<String, dynamic>,
                                ),
                              )
                              .where((s) => seenNames.add(s.name.toLowerCase()))
                              .where((s) {
                                if (_query.trim().isEmpty) return true;

                                final q = _query.toLowerCase();

                                return s.name.toLowerCase().contains(q) ||
                                    s.shortDescription.toLowerCase().contains(
                                      q,
                                    );
                              })
                              .toList();

                          if (seekers.isEmpty) {
                            return const Center(
                              child: Text("No job seekers found."),
                            );
                          }

                          return ListView.separated(
                            itemCount: seekers.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 5),
                            itemBuilder: (context, index) {
                              final seeker = seekers[index];

                              return ShortDescriptionRoundCircleIconTile(
                                height: 80,
                                width: double.infinity,
                                backgroundColor: ElevateColor.white,
                                borderRadius: 20,
                                imageURL: seeker.profilePic.isNotEmpty
                                    ? seeker.profilePic
                                    : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(seeker.name.isNotEmpty ? seeker.name : "User")}&background=E0E0E0&color=757575&size=128&bold=true',
                                name: seeker.name,
                                shortDescription: seeker.shortDescription,
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
                                          CompanyViewProfile(seeker: seeker),
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
