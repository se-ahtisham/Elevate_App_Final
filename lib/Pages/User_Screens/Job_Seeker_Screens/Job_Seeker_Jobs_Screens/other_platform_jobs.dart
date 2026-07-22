import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_compact_tile.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/platform_filter_chip.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/job_selection.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtherPlatformJobs extends ConsumerStatefulWidget {
  const OtherPlatformJobs({super.key});

  @override
  ConsumerState<OtherPlatformJobs> createState() => _OtherPlatformJobsState();
}

class _OtherPlatformJobsState extends ConsumerState<OtherPlatformJobs> {
  final _firebaseService = FirebaseService();

  bool isLoading = true;

  Map<String, Map<String, dynamic>> passedSkills = {};
  Map<String, CompanyModel> companiesByID = {};

  List<JobPostModel> allJobs = [];
  List<JobPostModel> filteredJobs = [];

  String? activeSkillID;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final myID = ref.read(authProvider).jobSeeker?.jobSeekerID;

    try {
      final companies = await _firebaseService.listAllCompanies();
      final companyMap = {for (final c in companies) c.companyID: c};

      if (myID != null) {
        final bestScores = await _firebaseService.getBestPassedScoresBySkill(myID);
        final allSkillList = await _firebaseService.listAllSkills();
        final skillsById = {for (final s in allSkillList) s.skillID: s};

        final map = <String, Map<String, dynamic>>{};
        final loadedJobs = <JobPostModel>[];
        final seenJobIDs = <String>{};

        for (final entry in bestScores.entries) {
          final skillID = entry.key;
          final score = entry.value;
          final skill = skillsById[skillID];
          if (skill == null) continue;

          final tier = FirebaseService.tierForScore(score);
          map[skillID] = {
            'id': skillID,
            'name': skill.skillName,
            'score': score,
            'tier': tier,
          };

          // Fetch jobs for this skill and tier (Gold -> Gold, Silver, Bronze; Silver -> Silver, Bronze; Bronze -> Bronze)
          final matchingJobs = await _firebaseService.getJobsForSkillTier(
            skillID,
            tier,
          );
          for (final j in matchingJobs) {
            if (seenJobIDs.add(j.jobID)) {
              loadedJobs.add(j);
            }
          }
        }

        // If no passed skill jobs found, fallback to viewAllJobs
        if (loadedJobs.isEmpty) {
          final fallbackJobs = await _firebaseService.viewAllJobs();
          for (final j in fallbackJobs) {
            if (!j.isClosed && seenJobIDs.add(j.jobID)) {
              loadedJobs.add(j);
            }
          }
        }

        if (!mounted) return;
        setState(() {
          passedSkills = map;
          companiesByID = companyMap;
          allJobs = loadedJobs;
          filteredJobs = loadedJobs;
          isLoading = false;
        });
      } else {
        final jobs = await _firebaseService.viewAllJobs();
        if (!mounted) return;
        setState(() {
          companiesByID = companyMap;
          allJobs = jobs.where((j) => !j.isClosed).toList();
          filteredJobs = allJobs;
          isLoading = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void selectSkill(String? skillID) {
    setState(() {
      activeSkillID = skillID;
      if (skillID == null) {
        filteredJobs = allJobs;
      } else {
        final skillInfo = passedSkills[skillID];
        final skillTier = skillInfo?['tier'] as String? ?? 'Bronze';
        final allowedJobTiers = FirebaseService.eligibleJobTiersFor(skillTier);

        filteredJobs = allJobs.where((j) {
          final hasSkill = j.requiredSkills.contains(skillID);
          final jobTier = FirebaseService.jobExperienceTier(j.experienceLevel);
          return hasSkill && allowedJobTiers.contains(jobTier);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            const ElevateHeader(
              title: "More Jobs",
              subTitle: "Jobs matched to your passed skills",
              titleSize: 26,
              subtitleSize: 14,
              showBackButton: true,
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  bottom: 30,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: IconText(
                        text: "Matched Positions",
                        iconData: Icons.work_outline,
                        textSize: 20,
                        textWeight: FontWeight.bold,
                        iconSize: 25,
                        iconTextSpacing: 10,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ── Passed Skill Filter Chips ───────────────
                    if (passedSkills.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: CustomText(
                          text: "YOUR PASSED SKILLS",
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: ElevateColor.gray,
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Row(
                          children: [
                            PlatformFilterChip(
                              label: "All Passed Skills",
                              isSelected: activeSkillID == null,
                              onTap: () => selectSkill(null),
                            ),
                            ...passedSkills.entries.map((entry) {
                              final name = entry.value['name'] as String;
                              final tier = entry.value['tier'] as String;
                              return PlatformFilterChip(
                                label: "$name ($tier)",
                                isSelected: activeSkillID == entry.key,
                                onTap: () => selectSkill(entry.key),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 10),
                      child: Text(
                        "${filteredJobs.length} jobs found",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Expanded(
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : filteredJobs.isEmpty
                              ? const Center(
                                  child: CustomText(
                                    text: "No jobs match the selected skill tier.",
                                    fontSize: 13,
                                    color: ElevateColor.gray,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  itemCount: filteredJobs.length,
                                  itemBuilder: (_, i) {
                                    final job = filteredJobs[i];
                                    final company =
                                        companiesByID[job.companyID];

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: JobCompactTile(
                                        title: job.title,
                                        company:
                                            company?.companyName ?? 'Company',
                                        location: job.location,
                                        isRemote: job.location
                                            .toLowerCase()
                                            .contains('remote'),
                                        jobType: job.jobType,
                                        salary: job.salary,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => JobSelection(
                                                jobPost: job,
                                                companyEmail: company?.email,
                                                companyName: company?.companyName ?? 'Company',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
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
