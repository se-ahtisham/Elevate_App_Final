import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/user_Comment_tile.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';

import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/post_model.dart';

class CompanyViewUserPost extends StatefulWidget {
  final String authorID;

  const CompanyViewUserPost({super.key, this.authorID = ''});

  @override
  State<CompanyViewUserPost> createState() => _CompanyViewUserPostState();
}

class _CompanyViewUserPostState extends State<CompanyViewUserPost> {
  final TextEditingController searchPostController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  String _searchQuery = '';

  late Future<List<PostModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _fetchPosts();
  }

  Future<List<PostModel>> _fetchPosts() async {
    if (widget.authorID.isEmpty) return [];
    final posts = await _firebaseService.getPostsByAuthor(widget.authorID);
    if (_searchQuery.isEmpty) return posts;
    return posts.where((p) => p.content.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  void dispose() {
    searchPostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElevateColor.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            ElevateHeader(
              title: "Candidate Posts",
              subTitle: "Explore posts shared by candidate",
              showBackButton: true,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSearchBar(
                      hintText: "Explore Posts",
                      iconData: Icons.search,
                      iconColor: const Color(0xFF1C1C3A),
                      controller: searchPostController,
                      width: 350,
                      height: 50,
                      textSize: 15,
                      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                          _postsFuture = _fetchPosts();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<PostModel>>(
                future: _postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No posts found."));
                  }

                  final posts = snapshot.data!;
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return FutureBuilder(
                        future: _firebaseService.getJobSeeker(post.authorID),
                        builder: (context, seekerSnapshot) {
                          if (seekerSnapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
                          }
                          final seeker = seekerSnapshot.data;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: UserCommentTile(
                              title: post.title,
                              text: post.content,
                              imageURL: (seeker != null && seeker.profilePic.isNotEmpty)
                                  ? seeker.profilePic
                                  : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(seeker?.name.isNotEmpty == true ? seeker!.name : "User")}&background=E0E0E0&color=757575&size=128&bold=true',
                              name: seeker != null ? seeker.name : 'Unknown User',
                              shortDescription: seeker != null ? seeker.shortDescription : 'Job Seeker',
                            ),
                          );
                        }
                      );
                    },
                  );
                }
              ),
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
}
