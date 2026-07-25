import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/featured_job_card.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_compact_tile.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_header.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_skill_filter_chip.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/job_selection.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/other_platform_jobs.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobScreen extends ConsumerStatefulWidget {
  final String niche;
  final String experience;

  const JobScreen({super.key, this.niche = '', this.experience = ''});

  @override
  ConsumerState<JobScreen> createState() => JobScreenState();
}

class JobScreenState extends ConsumerState<JobScreen> {
  final firebaseService = FirebaseService();

  bool isLoading = true;

  Map<String, Map<String, dynamic>> mySkills = {};
  Map<String, CompanyModel> companiesByID = {};
  List<CompanyModel> followedCompaniesList = [];
  List<CompanyModel> allCompaniesList = [];

  List<JobPostModel> allJobsList = [];
  List<JobPostModel> recommendedJobs = [];

  String? selectedCompanyID;
  String? selectedSkillID;
  String selectedTierFilter = 'All'; // 'All', 'Gold', 'Silver', 'Bronze'

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final jobSeeker = ref.read(authProvider).jobSeeker;
    final myID = jobSeeker?.jobSeekerID;
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

      final followedIDs = jobSeeker?.followedCompanies ?? [];
      final followedComps = companies
          .where((c) => followedIDs.contains(c.companyID))
          .toList();

      final allJobsSnap = await firebaseService.db
          .collection('jobs')
          .where('isClosed', isEqualTo: false)
          .get();

      final fetchedJobs = allJobsSnap.docs
          .map((d) => JobPostModel.fromMap(d.data()))
          .toList();

      if (!mounted) return;
      setState(() {
        mySkills = skillMap;
        recommendedJobs = recommended;
        companiesByID = companyMap;
        allCompaniesList = companies;
        followedCompaniesList = followedComps.isNotEmpty
            ? followedComps
            : companies;
        allJobsList = fetchedJobs;
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

  List<JobPostModel> get filteredJobs {
    List<JobPostModel> result = List.from(allJobsList);

    if (selectedCompanyID != null) {
      result = result
          .where((job) => job.companyID == selectedCompanyID)
          .toList();
    }

    if (selectedSkillID != null) {
      result = result
          .where((job) => job.requiredSkills.contains(selectedSkillID))
          .toList();
    }

    if (selectedTierFilter != 'All') {
      result = result.where((job) {
        final jobTier = FirebaseService.jobExperienceTier(job.experienceLevel);
        return jobTier == selectedTierFilter;
      }).toList();
    }

    return result;
  }

  void onSelectCompany(String? companyID) {
    setState(() {
      selectedCompanyID = selectedCompanyID == companyID ? null : companyID;
    });
  }

  void onSelectSkill(String? skillID) {
    setState(() {
      selectedSkillID = selectedSkillID == skillID ? null : skillID;
    });
  }

  void onSelectTier(String tier) {
    setState(() {
      selectedTierFilter = tier;
    });
  }

  String getInitials(String text) {
    final words = text.trim().split(' ');
    final letters = words.take(2).map((w) => w.isNotEmpty ? w[0] : '');
    return letters.join().toUpperCase();
  }

  String getBadgeSymbol(String tier) {
    switch (tier) {
      case 'Gold':
        return '🥇 Gold';
      case 'Silver':
        return '🥈 Silver';
      case 'Bronze':
        return '🥉 Bronze';
      default:
        return 'Unranked';
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayCompanies = followedCompaniesList.isNotEmpty
        ? followedCompaniesList
        : allCompaniesList;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header
                const JobScreenHeader(),
                const SizedBox(height: 24),

                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  )
                else ...[
                  // 2. RECOMMENDED FOR YOU (BLACK CARDS, UNFILTERED 10 MATCHES)
                  const CustomText(
                    text: 'Recommended For You',
                    fontSize: 16,
                    color: ElevateColor.gray,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 12),

                  recommendedJobs.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => JobSelection(
                                          jobPost: job,
                                          companyEmail: company?.email,
                                          companyName:
                                              company?.companyName ?? 'Company',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                  const SizedBox(height: 24),

                  // 3. YOUR PASSED SKILLS (OUTLINE CARDS, THEME MATCHED)
                  if (mySkills.isNotEmpty) ...[
                    const CustomText(
                      text: 'Your Passed Skills',
                      fontSize: 16,
                      color: ElevateColor.gray,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: mySkills.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final entry = mySkills.entries.elementAt(index);
                          final skillID = entry.key;
                          final name = entry.value['name'] as String;
                          final score = (entry.value['score'] as double)
                              .toStringAsFixed(0);
                          final tier = entry.value['tier'] as String;
                          final isSelected = selectedSkillID == skillID;

                          return GestureDetector(
                            onTap: () => onSelectSkill(skillID),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 160,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.grey.shade900
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.black
                                      : const Color(0xFFE0E0E0),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        getBadgeSymbol(tier),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected
                                              ? Colors.white70
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                                      Text(
                                        "$score%",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // 4. FOLLOWED COMPANIES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: 'Followed Companies',
                        fontSize: 16,
                        color: ElevateColor.gray,
                        fontWeight: FontWeight.w700,
                      ),
                      if (selectedCompanyID != null)
                        InkWell(
                          onTap: () => onSelectCompany(null),
                          child: const CustomText(
                            text: 'Show All Companies',
                            fontSize: 11,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: displayCompanies.length + 1,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          final isSelected = selectedCompanyID == null;
                          return GestureDetector(
                            onTap: () => onSelectCompany(null),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 75,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.black : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.black
                                      : const Color(0xFFE0E0E0),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.business,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black54,
                                    size: 22,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "All",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final company = displayCompanies[index - 1];
                        final isSelected =
                            selectedCompanyID == company.companyID;
                        final companyJobsCount = allJobsList
                            .where((j) => j.companyID == company.companyID)
                            .length;

                        return GestureDetector(
                          onTap: () => onSelectCompany(company.companyID),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 130,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.grey.shade900
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black
                                    : const Color(0xFFE0E0E0),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 11,
                                      backgroundColor: isSelected
                                          ? Colors.white24
                                          : Colors.grey.shade200,
                                      child: Text(
                                        getInitials(company.companyName),
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white24
                                            : Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "$companyJobsCount jobs",
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  company.companyName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 5. EXPERIENCE TIER FILTER CHIPS
                  const CustomText(
                    text: 'Experience Level',
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 10),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: ['All', 'Bronze', 'Silver', 'Gold'].map((tier) {
                        final isSelected = selectedTierFilter == tier;
                        String labelText;
                        switch (tier) {
                          case 'Bronze':
                            labelText = 'Bronze / Intern';
                            break;
                          case 'Silver':
                            labelText = 'Silver / Mid';
                            break;
                          case 'Gold':
                            labelText = 'Gold / Senior';
                            break;
                          default:
                            labelText = 'All';
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: JobSkillFilterChip(
                            text: labelText,
                            isSelected: isSelected,
                            selectedColor: const Color(0xFF333333),
                            onTap: () => onSelectTier(tier),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 6. FILTERED JOBS VERTICAL LISTING + MORE JOBS HEADER BUTTON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: selectedCompanyID != null
                            ? '${companiesByID[selectedCompanyID]?.companyName ?? "Company"} Jobs (${filteredJobs.length})'
                            : 'Matching Positions (${filteredJobs.length})',
                        fontSize: 16,
                        color: ElevateColor.gray,
                        fontWeight: FontWeight.w700,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OtherPlatformJobs(),
                            ),
                          );
                        },
                        child: Container(
                          height: 32,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
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

                  const SizedBox(height: 14),

                  if (filteredJobs.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: CustomText(
                          text: "No jobs match your active filters.",
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => JobSelection(
                                    jobPost: job,
                                    companyEmail: company?.email,
                                    companyName:
                                        company?.companyName ?? 'Company',
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 30),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
