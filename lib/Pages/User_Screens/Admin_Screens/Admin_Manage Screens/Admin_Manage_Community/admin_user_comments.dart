import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/admin_comment_tile.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/comment_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminUserComments extends StatefulWidget {
  final String postID;
  final String authorName; // just for the header title

  const AdminUserComments({
    super.key,
    required this.postID,
    required this.authorName,
  });

  @override
  State<AdminUserComments> createState() => _AdminUserCommentsState();
}

class _AdminUserCommentsState extends State<AdminUserComments> {
  final FirebaseService firebaseService = FirebaseService();

  List<CommentModel> comments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  Future<void> loadComments() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final fetched = await firebaseService.getComments(widget.postID);
      if (!mounted) return;
      setState(() {
        comments = fetched;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't load comments. Try again.")),
      );
    }
  }

  Future<void> deleteComment(CommentModel comment) async {
    try {
      await firebaseService.deleteComment(comment.commentID, widget.postID);
      if (!mounted) return;
      setState(() {
        comments.removeWhere((c) => c.commentID == comment.commentID);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete comment.")),
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
            Stack(
              children: [
                ElevateHeader(
                  title: "${widget.authorName}'s",
                  subTitle: "Comments",
                  titleSize: 28,
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
                  : comments.isEmpty
                  ? const Center(
                      child: CustomText(
                        text: "No comments on this post yet.",
                        fontSize: 15,
                        color: ElevateColor.gray,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: comments.map((comment) {
                          return AdminCommentTile(
                            title: "",
                            text: comment.commentText,
                            imageURL:
                                "lib/Resources/Images/Profile_Images/ahtisham_Profile_image.jpg",
                            name: comment.authorName,
                            shortDescription: "Commenter",
                            onTap: () => deleteComment(comment),
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
