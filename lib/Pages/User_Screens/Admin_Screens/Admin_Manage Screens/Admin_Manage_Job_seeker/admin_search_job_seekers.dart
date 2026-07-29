import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/experience_white_black_full.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Job_seeker/admin_view_job_seeker.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminSearchJobSeekers extends StatefulWidget {
  const AdminSearchJobSeekers({super.key});

  @override
  State<AdminSearchJobSeekers> createState() => _AdminSearchJobSeekersState();
}

class _AdminSearchJobSeekersState extends State<AdminSearchJobSeekers> {
  final FirebaseService firebaseService = FirebaseService();
  final TextEditingController searchController = TextEditingController();

  List<JobSeekerModel> allJobSeekers = [];
  List<JobSeekerModel> visibleJobSeekers = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAllJobSeekers();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadAllJobSeekers() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final fetched = await firebaseService.listAllJobSeekers();
      if (!mounted) return;
      setState(() {
        allJobSeekers = fetched;
        visibleJobSeekers = allJobSeekers;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't load job seekers. Try again.")),
      );
    }
  }

  void onSearchChanged(String query) {
    query = query.toLowerCase();

    setState(() {
      visibleJobSeekers = allJobSeekers.where((jobSeeker) {
        return jobSeeker.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  // Opens the full profile view for the tapped job seeker.
  void openProfile(JobSeekerModel seeker) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdminViewJobSeeker(jobSeeker: seeker)),
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
                  title: "Manage",
                  subTitle: "Job Seekers",
                  titleSize: 40,
                  subtitleSize: 25,
                ),
                Positioned(
                  top: 170,
                  right: 120,
                  child: TexxtButton(
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
                      hintText: "Search by email",
                      backgroundColor: ElevateColor.white,
                      width: 380,
                      height: 60,
                      textSize: 15,
                      iconSize: 30,
                      controller: searchController,
                      onChanged: onSearchChanged,
                    ),

                    const SizedBox(height: 20),

                    if (isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                      )
                    else if (visibleJobSeekers.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: CustomText(
                            text: "No job seekers found.",
                            fontSize: 15,
                            color: ElevateColor.gray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      Column(
                        children: visibleJobSeekers.map((seeker) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ExperienceWhiteBlackFull(
                              imageURL: seeker.profilePic.isNotEmpty
                                  ? seeker.profilePic
                                  : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(seeker.name.isNotEmpty ? seeker.name : "User")}&background=E0E0E0&color=757575&size=128&bold=true',
                              name: seeker.name,
                              shortDescription: seeker.about.isNotEmpty
                                  ? seeker.about
                                  : "Job Seeker",
                              experience: seeker.experienceLevel.isNotEmpty
                                  ? seeker.experienceLevel
                                  : "Not specified",
                              firstContainerWidth: 270,
                              experienceBoxWidth: 240,
                              onTap: () => openProfile(seeker),
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
