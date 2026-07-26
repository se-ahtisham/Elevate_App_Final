import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_white_black_full_tile.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Job/admin_delete_jobs.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/admin_manage.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminSearchJobs extends StatefulWidget {
  const AdminSearchJobs({super.key});

  @override
  State<AdminSearchJobs> createState() => _AdminSearchJobsState();
}

class _AdminSearchJobsState extends State<AdminSearchJobs> {
  final FirebaseService firebaseService = FirebaseService();
  final TextEditingController searchController = TextEditingController();

  List<JobPostModel> allJobs = [];
  List<JobPostModel> visibleJobs = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAllJobs();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

 Future<void> loadAllJobs() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final fetched = await firebaseService.viewAllJobs();
      if (!mounted) return;
      setState(() {
        allJobs = fetched;
        visibleJobs = allJobs;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't load jobs. Try again.")),
      );
    }
  }

  void onSearchChanged(String query) {
    query = query.toLowerCase();

    setState(() {
      visibleJobs = allJobs.where((job) {
        return job.title.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> openDeleteScreen(JobPostModel job) async {
    final wasDeleted = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminDeleteJobs(
          jobID: job.jobID,
          title: job.title,
          description: job.description,
        ),
      ),
    );
    if (wasDeleted == true) {
      loadAllJobs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            Stack(
              children: [
                Stack(
                  children: [
                    ElevateHeader(
                      title: "Manage",
                      subTitle: "Jobs",
                      titleSize: 40,
                      subtitleSize: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 250.0, top: 170),
                      child: TextButtonGradient(
                        text: "Dashboard",
                        height: 50,
                        width: 150,
                        borderRadius: 25,
                        buttonBackgroundColor: ElevateGradientColors.white,
                        textColor: Colors.black,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminManage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const IconText(
                      text: "Explore Jobs",
                      iconData: Icons.people_alt_outlined,
                      textSize: 20,
                      textWeight: FontWeight.bold,
                      iconSize: 25,
                      iconTextSpacing: 10,
                    ),
                    const SizedBox(height: 15),
                    CustomSearchBar(
                      hintText: "Search Job",
                      backgroundColor: ElevateColor.white,
                      width: 380,
                      height: 60,
                      textSize: 15,
                      iconSize: 30,
                      controller: searchController,
                      onChanged: onSearchChanged,
                    ),
                    const SizedBox(height: 10),

                    if (isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                      )
                    else if (visibleJobs.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: CustomText(
                            text: "No jobs found.",
                            fontSize: 15,
                            color: ElevateColor.gray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      Column(
                        children: visibleJobs.map((job) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: JobWhiteBlackFullTile(
                              titleText: job.title,
                              subtitleText: job.experienceLevel.isNotEmpty
                                  ? "Experience: ${job.experienceLevel}"
                                  : "Experience: Not specified",
                              jobTypeText: job.jobType.isNotEmpty
                                  ? job.jobType
                                  : "Not specified",
                              jobModeText: job.location.isNotEmpty
                                  ? job.location
                                  : "Not specified",
                              salaryText: job.salary,
                              tileHeight: 120,
                              blockFontSize: 9,
                              firstContainerWidth: 280,
                              secondContainerWidth: 70,
                              smallBoxWdith: 80,
                              onTap: () => openDeleteScreen(job),
                              sizedBetween: 3,
                              spaceBetweenSubtitleBlocks: 20,
                              spaceBetweenTitleSubtitle: 10,
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
