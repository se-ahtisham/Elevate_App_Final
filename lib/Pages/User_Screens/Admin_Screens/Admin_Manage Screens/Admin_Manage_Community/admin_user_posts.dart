import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/admin_post_tile.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/post_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Manage%20Screens/Admin_Manage_Community/admin_user_comments.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminUserPosts extends StatefulWidget {
  final JobSeekerModel jobSeeker;

  const AdminUserPosts({super.key, required this.jobSeeker});

  @override
  State<AdminUserPosts> createState() => _AdminUserPostsState();
}

class _AdminUserPostsState extends State<AdminUserPosts> {
  final FirebaseService firebaseService = FirebaseService();
  final TextEditingController searchController = TextEditingController();

  List<PostModel> allPosts = [];
  List<PostModel> visiblePosts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadPosts() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final snap = await firebaseService.db
          .collection('posts')
          .where('authorID', isEqualTo: widget.jobSeeker.jobSeekerID)
          .get();

      final fetched = snap.docs
          .map((d) => PostModel.fromMap(d.data()))
          .toList();
      fetched.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (!mounted) return;
      setState(() {
        allPosts = fetched;
        visiblePosts = applySearch();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't load posts. Try again.")),
      );
    }
  }

  List<PostModel> applySearch() {
    final query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) return allPosts;
    return allPosts
        .where((p) => p.title.toLowerCase().contains(query))
        .toList();
  }

  void onSearchChanged(String query) {
    setState(() => visiblePosts = applySearch());
  }

  Future<void> deletePost(PostModel post) async {
    try {
      await firebaseService.deletePost(post.postID);
      if (!mounted) return;
      setState(() {
        allPosts.removeWhere((p) => p.postID == post.postID);
        visiblePosts.removeWhere((p) => p.postID == post.postID);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to delete post.")));
    }
  }

  void openComments(PostModel post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminUserComments(
          postID: post.postID,
          authorName: widget.jobSeeker.name,
        ),
      ),
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
            ElevateHeader(
              title: widget.jobSeeker.name,
              subTitle: "Posts",
              titleSize: 32,
              subtitleSize: 20,
              showBackButton: true,
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
              child: CustomSearchBar(
                hintText: "Search by post title",
                backgroundColor: ElevateColor.white,
                width: 380,
                height: 60,
                textSize: 15,
                iconSize: 30,
                controller: searchController,
                onChanged: onSearchChanged,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    )
                  : visiblePosts.isEmpty
                  ? Center(
                      child: CustomText(
                        text: allPosts.isEmpty
                            ? "This user hasn't posted anything yet."
                            : "No posts match your search.",
                        fontSize: 15,
                        color: ElevateColor.gray,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: loadPosts,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: visiblePosts.map((post) {
                              return AdminPostTile(
                                key: ValueKey(post.postID),
                                title: post.title,
                                text: post.content,
                                commentCount: post.totalCommentCount,
                                comments: const [],
                                imageURL: post.authorProfilePic,
                                name: post.authorName.isNotEmpty
                                    ? post.authorName
                                    : widget.jobSeeker.name,
                                shortDescription:
                                    widget.jobSeeker.experienceLevel.isNotEmpty
                                    ? widget.jobSeeker.experienceLevel
                                    : "Job Seeker",
                                deleteonTap: () => deletePost(post),
                                viewCommentonTap: () => openComments(post),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
