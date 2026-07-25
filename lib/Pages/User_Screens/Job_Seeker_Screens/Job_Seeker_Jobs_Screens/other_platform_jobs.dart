import 'package:elevate_app/Custom_Widgets/Buttons/icon_text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Drop_Down_Menu/custom_drop_down.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_compact_tile.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_skill_filter_chip.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/platform_filter_chip.dart';
import 'package:elevate_app/Data_Model_Classes/Api_Models/api_job_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Services/job_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherPlatformJobs extends ConsumerStatefulWidget {
  const OtherPlatformJobs({super.key});

  @override
  ConsumerState<OtherPlatformJobs> createState() => OtherPlatformJobsState();
}

class OtherPlatformJobsState extends ConsumerState<OtherPlatformJobs> {
  final jobService = JobService();
  final firebaseService = FirebaseService();

  List<ApiJobModel> jobs = [];
  List<ApiJobModel> filteredJobs = [];
  List<String> passedSkillNames = [];
  List<Map<String, String>> passedSkillDetails = [];

  bool isLoading = true;
  bool hasError = false;

  String? selectedPlatform;
  String? selectedSkill;
  String? selectedCompany;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadPassedSkillsAndJobs();
  }

  Future<void> loadPassedSkillsAndJobs() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final myID = ref.read(authProvider).jobSeeker?.jobSeekerID;
      List<String> skillNames = [];
      List<Map<String, String>> skillDetails = [];

      if (myID != null) {
        final bestScores =
            await firebaseService.getBestPassedScoresBySkill(myID);
        final allSkills = await firebaseService.listAllSkills();
        final skillsById = {for (final s in allSkills) s.skillID: s};

        for (final entry in bestScores.entries) {
          final skill = skillsById[entry.key];
          if (skill != null && skill.skillName.isNotEmpty) {
            final score = entry.value;
            final tier = FirebaseService.tierForScore(score);
            skillNames.add(skill.skillName);
            skillDetails.add({
              'name': skill.skillName,
              'tier': tier,
              'category': skill.category.isNotEmpty ? skill.category : 'Tech',
            });
          }
        }
      }

      String searchTarget = skillNames.isNotEmpty
          ? skillNames.join(" ")
          : "Software Developer";

      List<ApiJobModel> fetchedJobs = [];
      try {
        fetchedJobs = await jobService.fetchAllJobs(searchTarget);
      } catch (_) {
        fetchedJobs = await jobService.fetchAllJobs("Developer");
      }

      if (!mounted) return;
      setState(() {
        passedSkillNames = skillNames;
        passedSkillDetails = skillDetails;
        jobs = fetchedJobs;
        isLoading = false;
      });
      applyFilters();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        jobs = [];
        filteredJobs = [];
        isLoading = false;
        hasError = true;
      });
    }
  }

  void applyFilters() {
    setState(() {
      filteredJobs = jobs.where((job) {
        final matchPlatform = selectedPlatform == null ||
            job.platform.toLowerCase() == selectedPlatform!.toLowerCase();

        final matchSkill = selectedSkill == null ||
            job.title.toLowerCase().contains(selectedSkill!.toLowerCase()) ||
            (job.description?.toLowerCase().contains(
                  selectedSkill!.toLowerCase(),
                ) ??
                false);

        final matchCompany = selectedCompany == null ||
            job.company.toLowerCase() == selectedCompany!.toLowerCase();

        final matchSearch = searchQuery.isEmpty ||
            job.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            job.company.toLowerCase().contains(searchQuery.toLowerCase()) ||
            job.location.toLowerCase().contains(searchQuery.toLowerCase());

        return matchPlatform && matchSkill && matchCompany && matchSearch;
      }).toList();
    });
  }

  void onSearch(String q) {
    searchQuery = q;
    applyFilters();
  }

  void onPlatformSelected(String? platform) {
    setState(() {
      selectedPlatform = selectedPlatform == platform ? null : platform;
    });
    applyFilters();
  }

  void onSkillSelected(String? skill) {
    setState(() {
      selectedSkill = selectedSkill == skill ? null : skill;
    });
    applyFilters();
  }

  void clearAllFilters() {
    setState(() {
      selectedPlatform = null;
      selectedSkill = null;
      selectedCompany = null;
      searchQuery = '';
    });
    applyFilters();
  }

  Future<void> openExternalApply(ApiJobModel job) async {
    final url = job.applyUrl;
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No direct apply URL available for this job."),
        ),
      );
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri != null) {
      try {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          await launchUrl(uri);
        }
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Opening ${job.platform}...")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final platforms = jobs
        .map((e) => e.platform)
        .where((p) => p.isNotEmpty)
        .toSet()
        .toList();

    final companies = jobs
        .map((e) => e.company)
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();

    final bool hasActiveFilters = selectedPlatform != null ||
        selectedSkill != null ||
        selectedCompany != null ||
        searchQuery.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            const ElevateHeader(
              title: "More Jobs",
              subTitle: "Skill-matched positions from external platforms",
              titleSize: 28,
              subtitleSize: 14,
              showBackButton: true,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const IconText(
                      text: "External Opportunities",
                      iconData: Icons.public_outlined,
                      textSize: 18,
                      textWeight: FontWeight.bold,
                      iconSize: 24,
                      iconTextSpacing: 8,
                    ),
                    const SizedBox(height: 12),
                    CustomSearchBar(
                      hintText: "Search title, company, location...",
                      backgroundColor: Colors.white,
                      width: double.infinity,
                      height: 48,
                      textSize: 13,
                      iconSize: 22,
                      onChanged: onSearch,
                    ),
                    if (passedSkillDetails.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const CustomText(
                        text: "Your Passed Skills",
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 6),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            JobSkillFilterChip(
                              text: "All Skills",
                              isSelected: selectedSkill == null,
                              onTap: () => onSkillSelected(null),
                            ),
                            const SizedBox(width: 8),
                            ...passedSkillDetails.map((skill) {
                              final name = skill['name']!;
                              final tier = skill['tier']!;
                              final labelText = "$name • $tier";
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: JobSkillFilterChip(
                                  text: labelText,
                                  isSelected: selectedSkill == name,
                                  onTap: () => onSkillSelected(name),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                    if (platforms.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const CustomText(
                        text: "Platforms",
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 6),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            PlatformFilterChip(
                              label: "All Platforms",
                              isSelected: selectedPlatform == null,
                              onTap: () => onPlatformSelected(null),
                            ),
                            ...platforms.map((p) {
                              return PlatformFilterChip(
                                label: p,
                                isSelected: selectedPlatform == p,
                                onTap: () => onPlatformSelected(p),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                    if (companies.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      CustomDropDown(
                        hintText: "All Companies",
                        items: companies,
                        value: selectedCompany,
                        height: 42,
                        borderRadius: 12,
                        hintTextSize: 12,
                        textSize: 12,
                        backgroundColor: Colors.white,
                        borderColor: const Color(0xFFE0DED8),
                        onChanged: (val) {
                          setState(() {
                            selectedCompany = val;
                          });
                          applyFilters();
                        },
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (!isLoading && !hasError)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${filteredJobs.length} jobs found",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          if (hasActiveFilters)
                            InkWell(
                              onTap: clearAllFilters,
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "Clear Filters",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : hasError
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.wifi_off,
                                        size: 48,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 12),
                                      const CustomText(
                                        text: "Failed to load external jobs",
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        width: 160,
                                        child: IconTextButtonGradient(
                                          text: "Retry",
                                          iconData: Icons.refresh,
                                          textSize: 14,
                                          textColor: Colors.white,
                                          borderRadius: 24,
                                          height: 44,
                                          startColor: const Color(0xFF595959),
                                          endColor: const Color(0xFF111111),
                                          onTap: loadPassedSkillsAndJobs,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : filteredJobs.isEmpty
                                  ? const Center(
                                      child: CustomText(
                                        text:
                                            "No jobs match your filter criteria.",
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    )
                                  : RefreshIndicator(
                                      onRefresh: loadPassedSkillsAndJobs,
                                      color: Colors.black,
                                      child: ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        padding: const EdgeInsets.only(
                                          bottom: 20,
                                          top: 4,
                                        ),
                                        itemCount: filteredJobs.length,
                                        itemBuilder: (context, index) {
                                          final job = filteredJobs[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: JobCompactTile(
                                              title: job.title,
                                              company:
                                                  "${job.company} • ${job.platform}",
                                              location: job.location,
                                              isRemote: job.isRemote,
                                              jobType:
                                                  job.jobType ?? "Full Time",
                                              salary:
                                                  job.salary ?? "Not disclosed",
                                              onTap: () =>
                                                  openExternalApply(job),
                                            ),
                                          );
                                        },
                                      ),
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
