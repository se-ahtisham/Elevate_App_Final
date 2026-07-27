import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Database/Online_Database/auth_service.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Posts_Screens/company_upload_job_screen.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Posts_Screens/show_applied_candidates_screen.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class CompanyPostedJobsScreen extends StatefulWidget {
  const CompanyPostedJobsScreen({super.key});

  @override
  State<CompanyPostedJobsScreen> createState() =>
      _CompanyPostedJobsScreenState();
}

class _CompanyPostedJobsScreenState extends State<CompanyPostedJobsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  final AuthService _authService = AuthService();

  List<JobPostModel> _getFilteredJobs(List<JobPostModel> jobs) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return jobs;

    return jobs.where((j) {
      final title = j.title.toLowerCase();
      final location = j.location.toLowerCase();
      final tags = [j.jobType, j.salary].join(' ').toLowerCase();

      return title.contains(q) || location.contains(q) || tags.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = _authService.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              _topHeader(),
              const SizedBox(height: 18),
              _searchBar(),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Posted Jobs',
                  style: TextStyle(
                    color: ElevateColor.gray,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('jobs')
                      .where('companyID', isEqualTo: currentUserId)
                      .orderBy('postedAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      // Attempt without orderBy to bypass indexing requirement initially
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('jobs')
                            .where('companyID', isEqualTo: currentUserId)
                            .snapshots(),
                        builder: (context, snap2) {
                          if (snap2.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snap2.hasError) {
                            return Center(child: Text("Error: ${snap2.error}"));
                          }
                          return _buildJobList(snap2.data?.docs ?? []);
                        },
                      );
                    }
                    return _buildJobList(snapshot.data?.docs ?? []);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobList(List<QueryDocumentSnapshot> docs) {
    if (docs.isEmpty) {
      return const Center(child: Text("No jobs posted yet."));
    }

    final jobs = docs.map((d) => JobPostModel.fromMap(d.data() as Map<String, dynamic>)).toList();
    final filteredJobs = _getFilteredJobs(jobs);

    if (filteredJobs.isEmpty) {
      return const Center(child: Text("No jobs match your search."));
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 30),
      itemCount: filteredJobs.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (_, index) {
        return _jobCard(filteredJobs[index]);
      },
    );
  }

  Widget _topHeader() {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE7E7E7),
          ),
          alignment: Alignment.center,
          child: Text(
            'C',
            style: TextStyle(
              color: ElevateColor.gray,
              fontWeight: FontWeight.w700,
              fontSize: 32,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Let's Upload Opportunity",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9A9A9A),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Company Portal',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 22,
                  color: ElevateColor.gray,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF555555), Color(0xFF111111)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.ios_share_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CompanyUploadJobScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, size: 21, color: Color(0xFF4D4D4D)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) {
                setState(() {
                  _query = v;
                });
              },
              cursorColor: ElevateColor.gray,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search Post',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9A9A9A),
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: const TextStyle(fontSize: 14, color: Color(0xFF4D4D4D)),
            ),
          ),
          if (_query.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchCtrl.clear();
                setState(() {
                  _query = '';
                });
              },
              child: const Icon(
                Icons.close_rounded,
                size: 18,
                color: Color(0xFF9A9A9A),
              ),
            ),
        ],
      ),
    );
  }

  Widget _jobCard(JobPostModel job) {
    final initials = job.title.isNotEmpty ? job.title.substring(0, 1).toUpperCase() : 'J';
    final tags = [job.jobType, job.location, job.salary].where((e) => e.isNotEmpty).toList();

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4A4A4A),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title.isNotEmpty ? job.title : "Untitled",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: Color(0xFF2B2B2B),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        job.location.isNotEmpty ? job.location : 'Remote',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF8B8B8B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 7,
                        runSpacing: 7,
                        children: tags
                            .map(
                              (tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F3F3),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF777777),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 58,
          height: 108,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFF5B5B5B), Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowAppliedCandidatesScreen(job: job),
                  ),
                );
              },
              child: const Center(
                child: Icon(
                  Icons.arrow_outward_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
