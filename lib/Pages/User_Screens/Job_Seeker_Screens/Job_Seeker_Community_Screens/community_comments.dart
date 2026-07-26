import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/user_Comment_tile.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/comment_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityComments extends ConsumerStatefulWidget {
  final String postID;
  final String postAuthorName;
  final String postTitle;

  const CommunityComments({
    super.key,
    required this.postID,
    required this.postAuthorName,
    this.postTitle = "",
  });

  @override
  ConsumerState<CommunityComments> createState() => CommunityCommentsState();
}

class CommunityCommentsState extends ConsumerState<CommunityComments> {
  final firebaseService = FirebaseService();
  final commentController = TextEditingController();

  List<CommentModel> comments = [];
  bool isLoading = true;
  bool isSending = false;
  String? loadError;

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> loadComments() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      loadError = null;
    });

    try {
      final fetched = await firebaseService.getComments(widget.postID);
      if (!mounted) return;
      setState(() {
        comments = fetched;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("loadComments failed: $e");
      if (!mounted) return;
      setState(() {
        isLoading = false;
        loadError = "Couldn't load comments. Pull to retry.";
      });
    }
  }

  Future<void> submitComment() async {
    final authState = ref.read(authProvider);
    final meSeeker = authState.jobSeeker;
    final meCompany = authState.company;

    final myID = meSeeker?.jobSeekerID ?? meCompany?.companyID;
    final myName = meSeeker?.name ?? meCompany?.companyName ?? "User";
    final text = commentController.text.trim();

    if (myID == null || text.isEmpty) return;

    setState(() => isSending = true);
    try {
      await firebaseService.addComment(
        widget.postID,
        myID,
        myName,
        text,
      );
      commentController.clear();
      await loadComments();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to post comment.")));
    } finally {
      if (mounted) setState(() => isSending = false);
    }
  }




  @override
  Widget build(BuildContext context) {
    final headerTitle = widget.postTitle.isNotEmpty
        ? widget.postTitle
        : "${widget.postAuthorName}'s post";

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 50,
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: headerTitle,
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 4),
                        CustomText(
                          text: "by ${widget.postAuthorName}",
                          fontSize: 13,
                          color: ElevateColor.gray,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  TextButtonGradient(
                    text: "Back",
                    width: 90,
                    height: 40,
                    textSize: 12,
                    textWeight: FontWeight.w500,
                    textColor: Colors.white,
                    borderColor: ElevateColor.gray,
                    borderRadius: 80,
                    borderWidth: 1,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      )
                    : loadError != null
                    ? RefreshIndicator(
                        onRefresh: loadComments,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 60),
                            child: Center(
                              child: CustomText(
                                text: loadError!,
                                fontSize: 14,
                                color: ElevateColor.gray,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                    : comments.isEmpty
                    ? RefreshIndicator(
                        onRefresh: loadComments,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 60),
                            child: Center(
                              child: CustomText(
                                text:
                                    "No comments yet. Be the first to comment.",
                                fontSize: 14,
                                color: ElevateColor.gray,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: loadComments,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: comments.map((comment) {
                              return Padding(
                                key: ValueKey(comment.commentID),
                                padding: const EdgeInsets.only(bottom: 12),
                                child: UserCommentTile(
                                  title: "",
                                  text: comment.commentText,
                                  imageURL: "",
                                  name: comment.authorName,
                                  shortDescription: "Member",
                                  onDeleteTap: null,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: ElevateColor.gray),
                        ),
                        child: TextField(
                          controller: commentController,
                          minLines: 1,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: "Write a comment...",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: isSending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Icon(Icons.send, color: Colors.black),
                      onPressed: isSending ? null : submitComment,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
