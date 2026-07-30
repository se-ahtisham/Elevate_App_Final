import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Database/Online_Database/auth_service.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/post_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Posts_Screens/company_upload_job_screen.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Posts_Screens/show_applied_candidates_screen.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/user_post_tile.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_post_new.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

enum PostTab { jobs, community }

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
  PostTab _activeTab = PostTab.jobs;

  CompanyModel? _company;
  bool _loadingCompany = true;

  final TextEditingController _postTitleCtrl = TextEditingController();
  final TextEditingController _postContentCtrl = TextEditingController();
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    _loadCompany();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _postTitleCtrl.dispose();
    _postContentCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCompany() async {
    final String currentUserId = _authService.currentUser?.uid ?? '';
    if (currentUserId.isEmpty) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('companies')
          .doc(currentUserId)
          .get();
      if (doc.exists && mounted) {
        setState(() {
          _company = CompanyModel.fromMap(doc.data()!);
          _loadingCompany = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading company: $e");
      if (mounted) {
        setState(() => _loadingCompany = false);
      }
    }
  }

  Future<void> _submitPost() async {
    final company = _company;
    final currentUserId = _authService.currentUser?.uid ?? '';
    final title = _postTitleCtrl.text.trim();
    final content = _postContentCtrl.text.trim();
    if (company == null || currentUserId.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post content cannot be empty.")),
      );
      return;
    }

    setState(() => _isPosting = true);

    try {
      final postID = FirebaseFirestore.instance.collection("posts").doc().id;
      final createdPost = PostModel(
        postID: postID,
        authorID: currentUserId,
        authorName: company.companyName,
        authorProfilePic: company.logo,
        authorType: "Company",
        title: title,
        content: content,
        mediaFiles: const [],
      );

      await FirebaseService().createPost(createdPost);

      _postTitleCtrl.clear();
      _postContentCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post created successfully!")),
      );
    } catch (e) {
      debugPrint("createPost failed: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to create post: $e")));
    } finally {
      if (mounted) {
        setState(() => _isPosting = false);
      }
    }
  }

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

  Widget _tabSwitcher() {
    return Row(
      children: [
        _tabButton("Jobs", PostTab.jobs),
        const SizedBox(width: 10),
        _tabButton("Community Posts", PostTab.community),
        SizedBox(width: 120),
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
              MaterialPageRoute(
                builder: (context) => const CompanyUploadJobScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _tabButton(String label, PostTab tab) {
    final isActive = _activeTab == tab;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = tab;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive ? Colors.black : const Color(0xFFE5E5E5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = _authService.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 244, 244),
      body: SafeArea(
        child: Column(
          children: [
            // Header without left/right padding
            _topHeader(),

            // Everything else keeps the same padding
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    _searchBar(),
                    const SizedBox(height: 15),
                    _tabSwitcher(),
                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _activeTab == PostTab.jobs
                            ? 'Posted Jobs'
                            : 'Community Feed',
                        style: TextStyle(
                          color: ElevateColor.gray,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Expanded(
                      child: _activeTab == PostTab.jobs
                          ? StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('jobs')
                                  .where('companyID', isEqualTo: currentUserId)
                                  .orderBy('postedAt', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.hasError) {
                                  return StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('jobs')
                                        .where(
                                          'companyID',
                                          isEqualTo: currentUserId,
                                        )
                                        .snapshots(),
                                    builder: (context, snap2) {
                                      if (snap2.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      if (snap2.hasError) {
                                        return Center(
                                          child: Text("Error: ${snap2.error}"),
                                        );
                                      }

                                      return _buildJobList(
                                        snap2.data?.docs ?? [],
                                      );
                                    },
                                  );
                                }

                                return _buildJobList(snapshot.data?.docs ?? []);
                              },
                            )
                          : _buildCommunityTab(currentUserId),
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

  Widget _buildCommunityTab(String currentUserId) {
    final logoUrl = _company?.logo.isNotEmpty == true
        ? _company!.logo
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(_company?.companyName ?? "Company")}&background=random&color=fff&size=128&bold=true';

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              _loadingCompany
                  ? const Center(child: CircularProgressIndicator())
                  : UserPostNew(
                      hintTitle: "Topic of your post",
                      hintText: "What's happening at your company?",
                      imageURL: logoUrl,
                      name: _company?.companyName ?? "Company",
                      shortDescription: _company?.industry ?? "Company",
                      titleController: _postTitleCtrl,
                      shortDescriptionController: _postContentCtrl,
                      onPost: _submitPost,
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .where('authorID', isEqualTo: currentUserId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return const Center(child: Text("No community posts yet."));
              }
              final posts = docs
                  .map(
                    (d) => PostModel.fromMap(d.data() as Map<String, dynamic>),
                  )
                  .toList();
              posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

              final filteredPosts = posts.where((p) {
                final q = _query.trim().toLowerCase();
                if (q.isEmpty) return true;
                return p.title.toLowerCase().contains(q) ||
                    p.content.toLowerCase().contains(q);
              }).toList();

              if (filteredPosts.isEmpty) {
                return const Center(child: Text("No posts match your search."));
              }

              return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 30),
                itemCount: filteredPosts.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (_, index) {
                  final post = filteredPosts[index];
                  return UserPostTile(
                    postID: post.postID,
                    title: post.title,
                    text: post.content,
                    commentCount: post.totalCommentCount,
                    comments: const [],
                    likeCount: post.likes,
                    isLiked: post.likedByUserIDs.contains(currentUserId),
                    imageURL: post.authorProfilePic.isNotEmpty
                        ? post.authorProfilePic
                        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(post.authorName.isNotEmpty ? post.authorName : "Company")}&background=random&color=fff&size=128&bold=true',
                    name: post.authorName.isNotEmpty
                        ? post.authorName
                        : 'Company',
                    shortDescription: 'Company',
                    onLikeTap: () async {
                      try {
                        await FirebaseService().likePost(
                          post.postID,
                          currentUserId,
                        );
                      } catch (e) {
                        debugPrint("Like post failed: $e");
                      }
                    },
                    onDeleteTap: () async {
                      try {
                        await FirebaseService().deletePost(post.postID);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Post deleted successfully"),
                          ),
                        );
                      } catch (e) {
                        debugPrint("Delete post failed: $e");
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildJobList(List<QueryDocumentSnapshot> docs) {
    if (docs.isEmpty) {
      return const Center(child: Text("No jobs posted yet."));
    }

    final jobs = docs
        .map((d) => JobPostModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
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
    return Column(
      children: [
        ElevateHeader(
          title: "Let's Upload Opportunity",
          subTitle: "Company Portal",
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
    final initials = job.title.isNotEmpty
        ? job.title.substring(0, 1).toUpperCase()
        : 'J';
    final tags = [
      job.jobType,
      job.location,
      job.salary,
    ].where((e) => e.isNotEmpty).toList();

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
