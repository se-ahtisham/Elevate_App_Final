import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/user_post_tile.dart';
import 'package:elevate_app/Custom_Widgets/User_Widgets/user_post_new.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/post_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Community_Screens/community_comments.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserCommunityMypost extends ConsumerStatefulWidget {
  const UserCommunityMypost({super.key});

  @override
  ConsumerState<UserCommunityMypost> createState() =>
      UserCommunityMypostState();
}

class UserCommunityMypostState extends ConsumerState<UserCommunityMypost>
    with AutomaticKeepAliveClientMixin {
  final firebaseService = FirebaseService();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  List<PostModel> myPosts = [];
  bool isLoading = true;
  bool isPosting = false;

  @override
  bool get wantKeepAlive => true;

  String? get myID => ref.read(authProvider).jobSeeker?.jobSeekerID;

  @override
  void initState() {
    super.initState();
    loadMyPosts();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> loadMyPosts() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final id = ref.read(authProvider).jobSeeker?.jobSeekerID;
    if (id == null) {
      if (!mounted) return;
      setState(() {
        myPosts = [];
        isLoading = false;
      });
      return;
    }

    try {
      final fetched = await firebaseService.getPostsByAuthor(id);
      if (!mounted) return;
      setState(() {
        myPosts = {for (final p in fetched) p.postID: p}.values.toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("loadMyPosts failed: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> submitPost() async {
    final user = ref.read(authProvider).jobSeeker;
    final title = titleController.text.trim();
    final content = descriptionController.text.trim();
    if (user == null || content.isEmpty) return;

    setState(() => isPosting = true);

    PostModel? createdPost;
    try {
      createdPost = PostModel(
        postID: firebaseService.db.collection("posts").doc().id,
        authorID: user.jobSeekerID,
        authorName: user.name,
        authorProfilePic: user.profilePic,
        authorType: "JobSeeker",
        title: title,
        content: content,
        mediaFiles: const [],
      );

      await firebaseService.createPost(createdPost);
      titleController.clear();
      descriptionController.clear();
    } catch (e) {
      debugPrint("createPost failed: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to create post.")));
      setState(() => isPosting = false);
      return;
    }

    if (!mounted) return;
    setState(() {
      myPosts = [createdPost!, ...myPosts];
      isPosting = false;
    });

    await loadMyPosts();
  }

  Future<void> deletePost(PostModel post) async {
    try {
      await firebaseService.deletePost(post.postID);
      if (!mounted) return;
      setState(() {
        myPosts.removeWhere((e) => e.postID == post.postID);
      });
    } catch (e) {
      debugPrint("deletePost failed: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to delete post.")));
    }
  }

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
        ),
      ),
    ).then((value) => loadMyPosts());
  }

  String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hr ago";
    return "${diff.inDays} d ago";
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = ref.watch(authProvider).jobSeeker;
    final uid = myID;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),

          if (user != null)
            UserPostNew(
              hintTitle: "Post Title",
              hintText: "Post Description",
              imageURL: user.profilePic.isNotEmpty
                   ? user.profilePic
                   : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.name.isNotEmpty ? user.name : "User")}&background=E0E0E0&color=757575&size=128&bold=true',
              name: user.name,
              shortDescription: "Job Seeker",
              titleController: titleController,
              shortDescriptionController: descriptionController,
              onPost: isPosting ? () {} : submitPost,
            ),

          const SizedBox(height: 30),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: CircularProgressIndicator(color: Colors.black),
              ),
            )
          else if (myPosts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(30),
              child: CustomText(
                text: "No post",
                fontSize: 15,
                color: ElevateColor.gray,
                fontWeight: FontWeight.w500,
              ),
            )
          else
            Column(
              children: [
                for (final post in myPosts)
                  Padding(
                    key: ValueKey(post.postID),
                    padding: const EdgeInsets.only(bottom: 20),
                    child: UserPostTile(
                      postID: post.postID,
                      timed: timeAgo(post.createdAt),
                      title: post.title,
                      text: post.content,
                      commentCount: post.totalCommentCount,
                      comments: const [],
                      likeCount: post.likes,
                      isLiked: uid != null && post.likedByUserIDs.contains(uid),
                      imageURL: post.authorProfilePic.isNotEmpty
                          ? post.authorProfilePic
                          : (post.authorType.toLowerCase() == 'company'
                              ? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(post.authorName.isNotEmpty ? post.authorName : "Company")}&background=E0E0E0&color=757575&size=128&bold=true'
                              : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(post.authorName.isNotEmpty ? post.authorName : "User")}&background=E0E0E0&color=757575&size=128&bold=true'),
                      name: post.authorName,
                      shortDescription: "Job Seeker",
                      onDeleteTap: () => deletePost(post),
                      onCommentsTap: () => openComments(post),
                      onLikeTap: () => toggleLike(post),
                    ),
                  ),
              ],
            ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
