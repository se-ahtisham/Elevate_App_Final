import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_post.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/post_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Community_Screens/community_comments.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserCommunityExploreScreen extends ConsumerStatefulWidget {
  const UserCommunityExploreScreen({super.key});

  @override
  ConsumerState<UserCommunityExploreScreen> createState() =>
      UserCommunityExploreScreenState();
}

enum ExploreFilter { all, jobSeekers, companies }

class UserCommunityExploreScreenState
    extends ConsumerState<UserCommunityExploreScreen> {
  final firebaseService = FirebaseService();
  final searchController = TextEditingController();

  List<PostModel> allPosts = [];
  List<PostModel> visiblePosts = [];
  ExploreFilter activeFilter = ExploreFilter.all;
  bool isLoading = true;

  String? get myID => ref.read(authProvider).jobSeeker?.jobSeekerID;

  @override
  void initState() {
    super.initState();
    loadFeed();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadFeed() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    final uid = myID;
    if (uid == null) {
      if (!mounted) return;
      setState(() {
        allPosts = [];
        visiblePosts = [];
        isLoading = false;
      });
      return;
    }
    final fetched = await firebaseService.getCommunityFeed(uid);
    if (!mounted) return;
    setState(() {
      allPosts = {for (final p in fetched) p.postID: p}.values.toList();
      visiblePosts = applyFilterAndSearch();
      isLoading = false;
    });
  }

  List<PostModel> applyFilterAndSearch() {
    List<PostModel> posts = allPosts;

    if (activeFilter == ExploreFilter.jobSeekers) {
      posts = posts.where((p) => p.authorType.toLowerCase() == 'jobseeker').toList();
    } else if (activeFilter == ExploreFilter.companies) {
      posts = posts.where((p) => p.authorType.toLowerCase() == 'company').toList();
    }

    final query = searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      posts = posts.where((post) {
        return post.authorName.toLowerCase().contains(query) ||
            post.title.toLowerCase().contains(query) ||
            post.content.toLowerCase().contains(query);
      }).toList();
    }

    return posts;
  }

  void onSearchChanged(String query) {
    setState(() {
      visiblePosts = applyFilterAndSearch();
    });
  }

  void setFilter(ExploreFilter filter) {
    setState(() {
      activeFilter = filter;
      visiblePosts = applyFilterAndSearch();
    });
  }

  // Optimistic like: flip local state immediately, no full-feed refetch.
  // Only revert + show an error if the Firestore write actually fails.
  Future<void> toggleLike(PostModel post) async {
    final uid = myID;
    if (uid == null) return;

    final wasLiked = post.likedByUserIDs.contains(uid);

    setState(() {
      if (wasLiked) {
        post.likedByUserIDs.remove(uid);
        post.likes = post.likes - 1;
      } else {
        post.likedByUserIDs.add(uid);
        post.likes = post.likes + 1;
      }
    });

    try {
      await firebaseService.likePost(post.postID, uid);
    } catch (e) {
      // Revert on failure since the optimistic update didn't actually stick.
      if (!mounted) return;
      setState(() {
        if (wasLiked) {
          post.likedByUserIDs.add(uid);
          post.likes = post.likes + 1;
        } else {
          post.likedByUserIDs.remove(uid);
          post.likes = post.likes - 1;
        }
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to update like.")));
    }
  }

  void openComments(PostModel post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityComments(
          postID: post.postID,
          postAuthorName: post.authorName,
          postTitle: post.title,
        ),
      ),
    ).then((value) => loadFeed());
  }

  Widget filterChip(String label, ExploreFilter filter) {
    final isActive = activeFilter == filter;

    return GestureDetector(
      onTap: () => setFilter(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : ElevateColor.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive ? Colors.black : ElevateColor.gray,
          ),
        ),
        child: CustomText(
          text: label,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isActive ? ElevateColor.white : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = myID;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          CustomSearchBar(
            hintText: "Explore Profiles",
            iconData: Icons.search,
            iconColor: const Color(0xFF1C1C3A),
            controller: searchController,
            onChanged: onSearchChanged,
            width: 350,
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                filterChip("All Posts", ExploreFilter.all),
                const SizedBox(width: 8),
                filterChip("Job Seekers", ExploreFilter.jobSeekers),
                const SizedBox(width: 8),
                filterChip("Companies", ExploreFilter.companies),
              ],
            ),
          ),
          const SizedBox(height: 25),

          const CustomText(
            text: "What's other Posted",
            fontSize: 16,
            color: ElevateColor.lightgray,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.left,
            lineHeight: 0.1,
          ),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: CircularProgressIndicator(color: Colors.black),
              ),
            )
          else if (visiblePosts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: CustomText(
                  text: "No post",
                  fontSize: 15,
                  color: ElevateColor.gray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            ...visiblePosts.map((post) {
              final isLiked = uid != null && post.likedByUserIDs.contains(uid);
              return UserPost(
                key: ValueKey(post.postID),
                userName: post.authorName,
                usershortDescription: post.authorType,
                image: post.authorProfilePic.isNotEmpty
                    ? post.authorProfilePic
                    : (post.authorType.toLowerCase() == 'company'
                        ? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(post.authorName.isNotEmpty ? post.authorName : "Company")}&background=E0E0E0&color=757575&size=128&bold=true'
                        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(post.authorName.isNotEmpty ? post.authorName : "User")}&background=E0E0E0&color=757575&size=128&bold=true'),
                postTitle: post.title,
                postText: post.content,
                textSize: 13,
                textWeight: FontWeight.w400,
                textAlign: TextAlign.justify,
                lineHeight: 1.3,
                commentCount: post.totalCommentCount,
                likeCount: post.likes,
                isLiked: isLiked,
                postDate: post.createdAt,
                onCommentsTap: () => openComments(post),
                onLikeTap: () => toggleLike(post),
              );
            }),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
