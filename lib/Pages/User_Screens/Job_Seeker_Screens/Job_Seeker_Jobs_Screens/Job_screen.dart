import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/featured_job_card.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_compact_tile.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_header.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_skill_filter_chip.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/other_platform_jobs.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobScreen extends ConsumerStatefulWidget {
  const JobScreen({super.key});

  @override
  ConsumerState<JobScreen> createState() => JobScreenState();
}

class JobScreenState extends ConsumerState<JobScreen> {
  final firebaseService = FirebaseService();

  bool isLoading = true;

  Map<String, Map<String, dynamic>> mySkills = {};
  Map<String, CompanyModel> companiesByID = {};

  List<JobPostModel> recommendedJobs = [];
  List<JobPostModel> otherPlatformJobs = [];

  String? activeSkillID;
  List<JobPostModel> filteredJobs = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final myID = ref.read(authProvider).jobSeeker?.jobSeekerID;
    if (myID == null) {
      if (!mounted) return;
      setState(() => isLoading = false);
      return;
    }

    try {
      final bestScores = await firebaseService.getBestPassedScoresBySkill(myID);
      final allSkills = await firebaseService.listAllSkills();
      final skillsById = {for (final s in allSkills) s.skillID: s};

      final skillMap = <String, Map<String, dynamic>>{};
      for (final entry in bestScores.entries) {
        final skill = skillsById[entry.key];
        if (skill == null) continue;
        skillMap[entry.key] = {
          'name': skill.skillName,
          'score': entry.value,
          'tier': FirebaseService.tierForScore(entry.value),
        };
      }

      final recommended = await firebaseService.getRecommendedJobs(
        myID,
        limit: 10,
      );

      final companies = await firebaseService.listAllCompanies();
      final companyMap = {for (final c in companies) c.companyID: c};

      final other = await firebaseService.getOtherPlatformJobs(
        excludeJobIDs: recommended.map((job) => job.jobID).toList(),
        limit: 10,
      );

      if (!mounted) return;
      setState(() {
        mySkills = skillMap;
        recommendedJobs = recommended;
        otherPlatformJobs = other;
        companiesByID = companyMap;
        activeSkillID = null;
        filteredJobs = recommended;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't load jobs. Pull to retry.")),
      );
    }
  }

  Future<void> selectSkill(String? skillID) async {
    if (skillID == null) {
      setState(() {
        activeSkillID = null;
        filteredJobs = recommendedJobs;
      });
      return;
    }

    setState(() => activeSkillID = skillID);

    final tier = mySkills[skillID]?['tier'] as String? ?? 'Bronze';
    final jobs = await firebaseService.getJobsForSkillTier(skillID, tier);

    if (!mounted) return;
    setState(() => filteredJobs = jobs);
  }

  String getInitials(String text) {
    final words = text.trim().split(' ');
    final letters = words.take(2).map((w) => w.isNotEmpty ? w[0] : '');
    return letters.join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  "lib/Animation/Welcome.gif",
                  width: 150,
                  height: 50,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 15),
                const JobScreenHeader(),
                const SizedBox(height: 30),

                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  )
                else ...[
                  const CustomText(
                    text: 'Recommended For You',
                    fontSize: 18,
                    color: ElevateColor.gray,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 12),

                  recommendedJobs.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: CustomText(
                            text:
                                "Pass a skill test to unlock matched jobs here.",
                            fontSize: 13,
                            color: ElevateColor.gray,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : SizedBox(
                          height: 190,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendedJobs.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 14),
                            itemBuilder: (context, index) {
                              final job = recommendedJobs[index];
                              final company = companiesByID[job.companyID];
                              String? companyName = company?.companyName;
                              if (companyName != null &&
                                  companyName.length > 30) {
                                companyName =
                                    "${companyName.substring(0, 30)}...";
                              }
                              return SizedBox(
                                width: 280,
                                child: FeaturedJobCard(
                                  initials: getInitials(
                                    company?.companyName ?? job.title,
                                  ),
                                  title: job.title.toUpperCase(),
                                  companyAndLocation:
                                      "${company?.companyName ?? 'Company'}  •  ${job.location}",
                                  description: job.description,
                                  jobType: job.jobType,
                                  salary: job.salary,
                                  onApplyTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Open job details'),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                  const SizedBox(height: 30),

                  if (mySkills.isNotEmpty) ...[
                    const CustomText(
                      text: 'Filter By Passed Skill',
                      fontSize: 16,
                      color: ElevateColor.gray,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 44,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: JobSkillFilterChip(
                              skillName: "All",
                              tier: "Bronze",
                              isActive: activeSkillID == null,
                              onTap: () => selectSkill(null),
                            ),
                          ),
                          ...mySkills.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: JobSkillFilterChip(
                                skillName: entry.value['name'] as String,
                                tier: entry.value['tier'] as String,
                                isActive: activeSkillID == entry.key,
                                onTap: () => selectSkill(entry.key),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (filteredJobs.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: CustomText(
                            text: "No jobs match this filter yet.",
                            fontSize: 13,
                            color: ElevateColor.gray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      Column(
                        children: filteredJobs.map((job) {
                          final company = companiesByID[job.companyID];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: JobCompactTile(
                              title: job.title,
                              company: company?.companyName ?? 'Company',
                              location: job.location,
                              salary: job.salary,
                              isRemote: job.location.toLowerCase().contains(
                                'remote',
                              ),
                              jobType: job.jobType,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Open job details'),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 30),
                  ],

                  Row(
                    children: [
                      const Expanded(
                        child: CustomText(
                          text: 'OTHER JOBS FOR YOU',
                          fontSize: 16,
                          color: ElevateColor.gray,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OtherPlatformJobs(
                                experience: "",
                                niche: "",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF595959), Color(0xFF111111)],
                            ),
                          ),
                          child: const Center(
                            child: CustomText(
                              text: 'MORE JOBS',
                              fontSize: 10,
                              color: ElevateColor.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  if (otherPlatformJobs.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: CustomText(
                          text: "No other jobs posted yet.",
                          fontSize: 13,
                          color: ElevateColor.gray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  else
                    Column(
                      children: otherPlatformJobs.map((job) {
                        final company = companiesByID[job.companyID];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: JobCompactTile(
                            title: job.title,
                            company: company?.companyName ?? 'Company',
                            location: job.location,
                            salary: job.salary,
                            isRemote: job.location.toLowerCase().contains(
                              'remote',
                            ),
                            jobType: job.jobType,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Open job details'),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
