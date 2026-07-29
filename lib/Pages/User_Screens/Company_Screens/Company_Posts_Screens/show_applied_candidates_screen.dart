import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_black_tile.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/experience_white_black_full.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Posts_Screens/company_view_applied_candidate_profile_screen.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:flutter/material.dart';

class ShowAppliedCandidatesScreen extends StatefulWidget {
  final JobPostModel job;
  const ShowAppliedCandidatesScreen({super.key, required this.job});

  @override
  State<ShowAppliedCandidatesScreen> createState() =>
      ShowAppliedCandidatesScreenState();
}

class ShowAppliedCandidatesScreenState
    extends State<ShowAppliedCandidatesScreen> {
  final TextEditingController searchCtrl = TextEditingController();
  List<JobSeekerModel> allCandidates = [];
  List<JobSeekerModel> filteredCandidates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCandidates();
  }

  Future<void> fetchCandidates() async {
    if (widget.job.applicants.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      List<JobSeekerModel> fetched = [];
      // Fetch each applicant profile
      for (String uid in widget.job.applicants) {
        final doc = await FirebaseFirestore.instance
            .collection('jobSeekers')
            .doc(uid)
            .get();
        if (doc.exists) {
          fetched.add(
            JobSeekerModel.fromMap(doc.data() as Map<String, dynamic>),
          );
        }
      }

      setState(() {
        allCandidates = fetched;
        filteredCandidates = fetched;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterCandidates(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredCandidates = allCandidates;
      });
    } else {
      final q = query.toLowerCase();
      setState(() {
        filteredCandidates = allCandidates
            .where(
              (c) =>
                  c.name.toLowerCase().contains(q) ||
                  c.shortDescription.toLowerCase().contains(q),
            )
            .toList();
      });
    }
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JobBlackTile(
              title: widget.job.title.isNotEmpty
                  ? widget.job.title
                  : "Untitled",
              company: "Company", // Ideally we fetch company name too
              location: widget.job.location.isNotEmpty
                  ? widget.job.location
                  : "Remote",
              description: widget.job.description,
              jobType: widget.job.jobType,
              jobMode: "Full Time",
              salary: widget.job.salary,
            ),
            const SizedBox(height: 15),
            CustomSearchBar(
              hintText: "Search Candidates",
              backgroundColor: ElevateColor.white,
              width: 380,
              height: 60,
              textSize: 15,
              iconSize: 30,
              controller: searchCtrl,
              onChanged: filterCandidates,
            ),
            const SizedBox(height: 15),
            const IconText(
              text: "Applied Candidates",
              iconData: Icons.people_alt_outlined,
              textSize: 15,
              textWeight: FontWeight.bold,
              iconSize: 20,
              iconTextSpacing: 10,
            ),
            const SizedBox(height: 15),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredCandidates.isEmpty
                  ? const Center(child: Text("No candidates found."))
                  : ListView.separated(
                      itemCount: filteredCandidates.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        final candidate = filteredCandidates[index];
                        return ExperienceWhiteBlackFull(
                          imageURL: candidate.profilePic.isNotEmpty
                              ? candidate.profilePic
                              : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(candidate.name.isNotEmpty ? candidate.name : "User")}&background=E0E0E0&color=757575&size=128&bold=true',
                          name: candidate.name,
                          shortDescription: candidate.shortDescription,
                          experience: candidate.experienceLevel,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CompanyViewAppliedCandidateProfileScreen(
                                      candidate: candidate,
                                      job: widget.job,
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: 15),
            TextButtonGradient(
              text: "BACK",
              height: 50,
              textSize: 14,
              textWeight: FontWeight.w400,
              borderRadius: 50,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),
            TexxtButton(
              text: "DELETE JOB POST",
              height: 50,
              textSize: 14,
              textColor: Colors.red.shade700,
              textWeight: FontWeight.bold,
              borderRadius: 50,
              backgroundColor: Colors.red.shade50,
              borderColor: Colors.red.shade300,
              borderWidth: 1,
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Delete Job Post"),
                    content: const Text(
                        "Are you sure you want to delete this job post?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('jobs')
                        .doc(widget.job.jobID)
                        .delete();

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Job post deleted.")),
                    );
                    Navigator.pop(context, true);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to delete job post: $e")),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
