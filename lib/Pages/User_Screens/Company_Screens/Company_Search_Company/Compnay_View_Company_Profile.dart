import "package:elevate_app/Custom_Widgets/Header/elevate_header.dart";
import "package:elevate_app/Custom_Widgets/Text/custom_text.dart";
import "package:elevate_app/Custom_Widgets/Text/icon_text.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_description.dart";
import "package:elevate_app/Custom_Widgets/User_Widgets/user_socialMedia.dart";
import "package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart";
import "package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_employee_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/post_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_seeker_model.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/job_selection.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/user_post_tile.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/icon_text_button.dart';

class CompnayViewCompanyProfile extends StatefulWidget {
  final CompanyModel company;
  const CompnayViewCompanyProfile({super.key, required this.company});

  @override
  State<CompnayViewCompanyProfile> createState() => _CompnayViewCompanyProfileState();
}

class _CompnayViewCompanyProfileState extends State<CompnayViewCompanyProfile> {
  final _firebaseService = FirebaseService();
  Future<List<Map<String, dynamic>>>? _activeEmployeesFuture;
  Future<List<JobPostModel>>? _jobsFuture;
  Future<List<PostModel>>? _postsFuture;

  @override
  void initState() {
    super.initState();
    _activeEmployeesFuture = _fetchActiveEmployees(widget.company.companyID);
    _jobsFuture = _fetchJobs(widget.company.companyID);
    _postsFuture = _fetchPosts(widget.company.companyID);
  }

  Future<List<Map<String, dynamic>>> _fetchActiveEmployees(String companyId) async {
    final all = await _firebaseService.getEmployeesByCompany(companyId);
    final active = all.where((e) => e.employeeStatus == 'Active').toList();
    List<Map<String, dynamic>> list = [];
    for (final emp in active) {
      final seeker = await _firebaseService.getJobSeeker(emp.jobSeekerID);
      if (seeker != null) {
        list.add({'emp': emp, 'seeker': seeker});
      }
    }
    return list;
  }

  Future<List<JobPostModel>> _fetchJobs(String companyId) async {
    return await _firebaseService.getJobsByCompany(companyId);
  }

  Future<List<PostModel>> _fetchPosts(String companyId) async {
    final all = await _firebaseService.listAllPosts();
    return all.where((p) => p.authorID == companyId).toList();
  }

  @override
  Widget build(BuildContext context) {
    final company = widget.company;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ElevateHeader(
                  title: "Company Profile",
                  subTitle: "Account Control Center",
                  showBackButton: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 20),
                  child: UserDescription(
                    imageURL: company.logo.isNotEmpty
                        ? company.logo
                        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(company.companyName.isNotEmpty ? company.companyName : "Company")}&background=E0E0E0&color=757575&size=128&bold=true',
                    name: company.companyName,
                    shortDescription: company.industry,
                    skills: company.activeJobs,
                    followers: company.followersCount,
                    followings: 0,
                    showSkills: false,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),

                      CustomText(
                        text: "ABOUT US",
                        fontSize: 20,
                        color: ElevateColor.lightgray,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        lineHeight: 1.0,
                      ),
                      const SizedBox(height: 12),
                      CustomText(
                        text: company.description.isNotEmpty
                            ? company.description
                            : "No description available.",
                        fontSize: 13,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.justify,
                        lineHeight: 1.3,
                      ),
                      const SizedBox(height: 22),
                      UserSocialmedia(
                        city: company.location,
                        country: "",
                        email: company.email,
                        web: company.website,
                      ),

                      const SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Company Achievements",
                            fontSize: 20,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          const SizedBox(height: 15),
                          if (company.achievementList.isEmpty)
                            CustomText(
                              text: "No achievements listed.",
                              fontSize: 12,
                              color: ElevateColor.whitegray,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.left,
                              lineHeight: 1.2,
                            )
                          else
                            ...company.achievementList.map(
                              (a) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: IconText(
                                  text: a,
                                  iconData: Icons.emoji_events_outlined,
                                  iconColor: ElevateColor.lightgray,
                                  iconSize: 30,
                                  iconTextSpacing: 8,
                                  textSize: 12,
                                  textColor: ElevateColor.lightgray,
                                  textWeight: FontWeight.w400,
                                  lineHeight: 1.2,
                                ),
                              ),
                            ),

                          const SizedBox(height: 30),
                          CustomText(
                            text: "Company Strengths",
                            fontSize: 20,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            text: company.companyStrengthList.isNotEmpty
                                ? company.companyStrengthList.join(" • ")
                                : "No strengths listed.",
                            fontSize: 12,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.left,
                            lineHeight: 1.2,
                          ),

                          const SizedBox(height: 30),
                          CustomText(
                            text: "Company Weaknesses",
                            fontSize: 20,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            text: company.companyWeaknessList.isNotEmpty
                                ? company.companyWeaknessList.join(" • ")
                                : "No weaknesses listed.",
                            fontSize: 12,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.left,
                            lineHeight: 1.2,
                          ),
                          
                          const SizedBox(height: 30),
                          CustomText(
                            text: "Working Employees",
                            fontSize: 20,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          const SizedBox(height: 12),
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: _activeEmployeesFuture,
                            builder: (context, empSnapshot) {
                              if (empSnapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              final list = empSnapshot.data ?? [];
                              if (list.isEmpty) {
                                return CustomText(
                                  text: "No active employees found.",
                                  fontSize: 12,
                                  color: ElevateColor.whitegray,
                                );
                              }
                              return SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    final item = list[index];
                                    final JobSeekerModel seeker = item['seeker'];
                                    final CompanyEmployeeModel emp = item['emp'];
                                    return Container(
                                      width: 100,
                                      margin: const EdgeInsets.only(right: 12),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(seeker.profilePic),
                                          ),
                                          const SizedBox(height: 6),
                                          CustomText(
                                            text: seeker.name,
                                            fontSize: 12,
                                            color: ElevateColor.lightgray,
                                            fontWeight: FontWeight.bold,
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                          ),
                                          CustomText(
                                            text: emp.position,
                                            fontSize: 10,
                                            color: ElevateColor.whitegray,
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 30),
                          CustomText(
                            text: "Job Posts",
                            fontSize: 20,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          const SizedBox(height: 12),
                          FutureBuilder<List<JobPostModel>>(
                            future: _jobsFuture,
                            builder: (context, jobsSnapshot) {
                              if (jobsSnapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              final list = jobsSnapshot.data ?? [];
                              if (list.isEmpty) {
                                return CustomText(
                                  text: "No jobs posted yet.",
                                  fontSize: 12,
                                  color: ElevateColor.whitegray,
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  final job = list[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: ElevateColor.lightgray.withOpacity(0.2)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                text: job.title,
                                                fontSize: 15,
                                                color: ElevateColor.lightgray,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              const SizedBox(height: 4),
                                              CustomText(
                                                text: "${job.location} • ${job.salary}",
                                                fontSize: 12,
                                                color: ElevateColor.whitegray,
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconTextButton(
                                          text: "VIEW JOB",
                                          iconData: Icons.arrow_forward,
                                          backgroundColor: ElevateColor.white,
                                          iconColor: ElevateColor.lightgray,
                                          textColor: ElevateColor.gray,
                                          textWeight: FontWeight.bold,
                                          borderColor: ElevateColor.gray,
                                          borderRadius: 50,
                                          textSize: 9,
                                          onTap: () {
                                            Navigator.of(context, rootNavigator: true).push(
                                              MaterialPageRoute(
                                                builder: (context) => JobSelection(
                                                  jobPost: job,
                                                  companyName: company.companyName,
                                                  companyEmail: company.email,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),

                          const SizedBox(height: 30),
                          CustomText(
                            text: "Community Posts",
                            fontSize: 20,
                            color: ElevateColor.lightgray,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.left,
                            lineHeight: 1.0,
                          ),
                          const SizedBox(height: 12),
                          FutureBuilder<List<PostModel>>(
                            future: _postsFuture,
                            builder: (context, postsSnapshot) {
                              if (postsSnapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              final list = postsSnapshot.data ?? [];
                              if (list.isEmpty) {
                                return CustomText(
                                  text: "No community posts yet.",
                                  fontSize: 12,
                                  color: ElevateColor.whitegray,
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  final post = list[index];
                                  return UserPostTile(
                                    postID: post.postID,
                                    title: post.title,
                                    text: post.content,
                                    commentCount: post.totalCommentCount,
                                    comments: const [],
                                    imageURL: post.authorProfilePic.isNotEmpty
                                        ? post.authorProfilePic
                                        : company.logo,
                                    name: post.authorName,
                                    shortDescription: company.industry,
                                    likeCount: post.likes,
                                    isLiked: false,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
