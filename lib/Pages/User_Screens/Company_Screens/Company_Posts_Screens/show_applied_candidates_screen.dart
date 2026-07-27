import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_black_tile.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/experience_white_black_full.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Posts_Screens/company_view_applied_candidate_profile_screen.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class ShowAppliedCandidatesScreen extends StatefulWidget {
  final JobPostModel job;
  const ShowAppliedCandidatesScreen({super.key, required this.job});

  @override
  State<ShowAppliedCandidatesScreen> createState() => _ShowAppliedCandidatesScreenState();
}

class _ShowAppliedCandidatesScreenState extends State<ShowAppliedCandidatesScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<JobSeekerModel> _allCandidates = [];
  List<JobSeekerModel> _filteredCandidates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCandidates();
  }

  Future<void> _fetchCandidates() async {
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
        final doc = await FirebaseFirestore.instance.collection('jobSeekers').doc(uid).get();
        if (doc.exists) {
          fetched.add(JobSeekerModel.fromMap(doc.data() as Map<String, dynamic>));
        }
      }
      
      setState(() {
        _allCandidates = fetched;
        _filteredCandidates = fetched;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterCandidates(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredCandidates = _allCandidates;
      });
    } else {
      final q = query.toLowerCase();
      setState(() {
        _filteredCandidates = _allCandidates.where((c) => 
          c.name.toLowerCase().contains(q) || 
          c.shortDescription.toLowerCase().contains(q)
        ).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
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
              title: widget.job.title.isNotEmpty ? widget.job.title : "Untitled",
              company: "Company", // Ideally we fetch company name too
              location: widget.job.location.isNotEmpty ? widget.job.location : "Remote",
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
              controller: _searchCtrl,
              onChanged: _filterCandidates,
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
                : _filteredCandidates.isEmpty 
                  ? const Center(child: Text("No candidates found."))
                  : ListView.separated(
                      itemCount: _filteredCandidates.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        final candidate = _filteredCandidates[index];
                        return ExperienceWhiteBlackFull(
                          imageURL: candidate.profilePic.isNotEmpty 
                            ? candidate.profilePic 
                            : "lib/Resources/Images/Profile_Images/default_profile.png",
                          name: candidate.name,
                          shortDescription: candidate.shortDescription,
                          experience: candidate.experienceLevel,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CompanyViewAppliedCandidateProfileScreen(candidate: candidate, job: widget.job),
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
    );
  }
}
