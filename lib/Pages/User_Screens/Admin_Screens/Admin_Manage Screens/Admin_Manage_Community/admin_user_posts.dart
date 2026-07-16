import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
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

  List<PostModel> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  // NOTE: firebase_service.dart has no getPostsByAuthor(authorID) helper,
  // so this queries Firestore directly via firebaseService.db.
  Future<void> loadPosts() async {
    setState(() => isLoading = true);

    final snap = await firebaseService.db
        .collection('posts')
        .where('authorID', isEqualTo: widget.jobSeeker.jobSeekerID)
        .orderBy('createdAt', descending: true)
        .get();

    setState(() {
      posts = snap.docs.map((d) => PostModel.fromMap(d.data())).toList();
      isLoading = false;
    });
  }

  Future<void> deletePost(PostModel post) async {
    try {
      await firebaseService.deletePost(post.postID);
      setState(() {
        posts.removeWhere((p) => p.postID == post.postID);
      });
    } catch (e) {
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
            Stack(
              children: [
                ElevateHeader(
                  title: widget.jobSeeker.name,
                  subTitle: "Posts",
                  titleSize: 32,
                  subtitleSize: 20,
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
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    )
                  : posts.isEmpty
                  ? const Center(
                      child: CustomText(
                        text: "This user hasn't posted anything yet.",
                        fontSize: 15,
                        color: ElevateColor.gray,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: posts.map((post) {
                          return AdminPostTile(
                            title: post.title,
                            text: post.content,
                            commentCount: post.totalCommentCount,
                            comments: const [],
                            imageURL: post.authorProfilePic.isNotEmpty
                                ? post.authorProfilePic
                                : "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
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
          ],
        ),
      ),
    );
  }
}
