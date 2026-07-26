import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Message_Box/deleteBox.dart';
import 'package:elevate_app/Custom_Widgets/Message_Box/messageBox.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/experience_white_black_full.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminDeleteJobSeekers extends StatefulWidget {
  const AdminDeleteJobSeekers({super.key});

  @override
  State<AdminDeleteJobSeekers> createState() => _AdminDeleteJobSeekersState();
}

class _AdminDeleteJobSeekersState extends State<AdminDeleteJobSeekers> {
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

  void confirmDelete(JobSeekerModel seeker) {
    showDialog(
      context: context,
      builder: (_) =>
          Deletebox(name: seeker.name, onDelete: () => deleteJobSeeker(seeker)),
    );
  }

Future<void> deleteJobSeeker(JobSeekerModel seeker) async {
    try {
      await firebaseService.deleteJobSeeker(seeker.jobSeekerID);

      if (!mounted) return;
      setState(() {
        allJobSeekers.removeWhere(
          (item) => item.jobSeekerID == seeker.jobSeekerID,
        );

        visibleJobSeekers.removeWhere(
          (item) => item.jobSeekerID == seeker.jobSeekerID,
        );
      });

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) =>
            Messagebox(message: "${seeker.name} deleted successfully."),
      );
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => const Messagebox(message: "Failed to delete job seeker."),
      );
    }
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
            const ElevateHeader(
              title: "Manage",
              subTitle: "Job Seekers",
              titleSize: 40,
              subtitleSize: 25,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "Delete Job Seekers",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ElevateColor.black,
                    ),

                    const SizedBox(height: 15),

                    CustomSearchBar(
                      hintText: "Search by name",
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
                          child: CircularProgressIndicator(color: Colors.black,),
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
                                  : "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                              name: seeker.name,
                              shortDescription: seeker.about.isNotEmpty
                                  ? seeker.about
                                  : "Job Seeker",
                              experience: seeker.experienceLevel.isNotEmpty
                                  ? seeker.experienceLevel
                                  : "Not specified",
                              firstContainerWidth: 270,
                              experienceBoxWidth: 240,
                              iconData: Icons.delete,
                              onTap: () => confirmDelete(seeker),
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
