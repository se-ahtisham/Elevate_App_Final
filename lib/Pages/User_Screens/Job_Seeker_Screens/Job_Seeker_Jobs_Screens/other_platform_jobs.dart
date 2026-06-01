// Fake  APi Cal
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_compact_tile.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/platform_filter_chip.dart';
import 'package:elevate_app/Data_Model_Classes/api_job_model.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/job_selection.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtherPlatformJobs extends StatefulWidget {
  final String niche;
  final String experience;

  const OtherPlatformJobs({
    super.key,
    required this.niche,
    required this.experience,
  });

  @override
  State<OtherPlatformJobs> createState() => _OtherPlatformJobsState();
}

class _OtherPlatformJobsState extends State<OtherPlatformJobs> {
  List<ApiJobModel> jobs = [];
  List<ApiJobModel> filtered = [];

  String? selectedPlatform;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadMockData();
  }

  void loadMockData() {
    jobs = [
      ApiJobModel(
        id: "1",
        title: "Senior Flutter Developer",
        company: "Google",
        location: "Remote",
        isRemote: true,
        jobType: "Full Time",
        salary: "\$6000 - \$8000",
        platform: "LinkedIn",
        postedAt: DateTime.now(),
        description:
            "Build high-performance Flutter apps with modern UI/UX and scalable architecture.",
        applyUrl: "https://example.com",
      ),

      ApiJobModel(
        id: "2",
        title: "Android Engineer",
        company: "Meta",
        location: "California, USA",
        isRemote: false,
        jobType: "Full Time",
        salary: "\$4500 - \$7000",
        platform: "Indeed",
        postedAt: DateTime.now(),
        description:
            "Develop and maintain Android applications used by millions of users.",
        applyUrl: "https://example.com",
      ),

      ApiJobModel(
        id: "3",
        title: "UI/UX Designer",
        company: "Figma",
        location: "Remote",
        isRemote: true,
        jobType: "Contract",
        salary: "\$2500 - \$4000",
        platform: "Glassdoor",
        postedAt: DateTime.now(),
        description:
            "Design clean, user-friendly interfaces and improve user experience across platforms.",
        applyUrl: "https://example.com",
      ),

      ApiJobModel(
        id: "4",
        title: "Full Stack Developer",
        company: "Amazon",
        location: "London, UK",
        isRemote: false,
        jobType: "Full Time",
        salary: "\$7000 - \$9000",
        platform: "LinkedIn",
        postedAt: DateTime.now(),
        description:
            "Work on scalable backend systems and modern frontend applications.",
        applyUrl: "https://example.com",
      ),

      ApiJobModel(
        id: "5",
        title: "Flutter Intern",
        company: "StartupX",
        location: "Remote",
        isRemote: true,
        jobType: "Internship",
        salary: "\$500 - \$1000",
        platform: "Indeed",
        postedAt: DateTime.now(),
        description:
            "Learn Flutter development by building real-world mobile applications.",
        applyUrl: "https://example.com",
      ),
    ];

    filtered = jobs;
    setState(() {});
  }

  void applyFilters() {
    setState(() {
      filtered = jobs.where((j) {
        final matchPlatform =
            selectedPlatform == null || j.platform == selectedPlatform;

        final matchSearch =
            searchQuery.isEmpty ||
            j.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            j.company.toLowerCase().contains(searchQuery.toLowerCase());

        return matchPlatform && matchSearch;
      }).toList();
    });
  }

  void onSearch(String q) {
    searchQuery = q;
    applyFilters();
  }

  void onPlatform(String? p) {
    selectedPlatform = p;
    applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final platforms = jobs.map((e) => e.platform).toSet().toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            ElevateHeader(
              title: "${widget.niche} Jobs",
              subTitle: "Skill-verified positions worldwide",
              titleSize: 30,
              subtitleSize: 14,
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 30.0,
                  bottom: 50,
                  right: 30,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: IconText(
                        text: "Explore Jobs",
                        iconData: Icons.people_alt_outlined,
                        textSize: 20,
                        textWeight: FontWeight.bold,
                        iconSize: 25,
                        iconTextSpacing: 10,
                      ),
                    ),

                    SizedBox(height: 15),

                    CustomSearchBar(
                      hintText: "Search jobs...",
                      backgroundColor: ElevateColor.white,
                      width: 370,
                      height: 50,
                      textSize: 15,
                      iconSize: 30,
                      onChanged: onSearch,
                    ),
                    SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          PlatformFilterChip(
                            label: "All",
                            isSelected: selectedPlatform == null,
                            onTap: () => onPlatform(null),
                          ),
                          ...platforms.map(
                            (p) => PlatformFilterChip(
                              label: p,
                              isSelected: selectedPlatform == p,
                              onTap: () => onPlatform(p),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 30, bottom: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("${filtered.length} jobs found"),
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final job = filtered[i];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: JobCompactTile(
                              title: job.title,
                              company: job.company,
                              location: job.location,
                              isRemote: job.isRemote,
                              jobType: job.jobType ?? "Full Time",
                              salary: job.salary ?? "Not disclosed",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => JobSelection(job: job),
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

/*
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Search_Bar/custom_search_bar.dart';
import 'package:elevate_app/Custom_Widgets/Text/icon_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_compact_tile.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/platform_filter_chip.dart';
import 'package:elevate_app/Data_Model_Classes/api_job_model.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/job_selection.dart';
import 'package:elevate_app/Services/job_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtherPlatformJobs extends StatefulWidget {
  final String niche;
  final String experience;

  const OtherPlatformJobs({
    super.key,
    required this.niche,
    required this.experience,
  });

  @override
  State<OtherPlatformJobs> createState() => _OtherPlatformJobsState();
}

class _OtherPlatformJobsState extends State<OtherPlatformJobs> {
  final service = JobService();

  List<ApiJobModel> jobs = [];
  List<ApiJobModel> filtered = [];

  bool loading = true;
  bool hasError = false;

  String? selectedPlatform;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    load();
  }

  String get query => "${widget.niche} ${widget.experience}";

  Future<void> load() async {
    setState(() {
      loading = true;
      hasError = false;
    });

    try {
      final data = await service.fetchAllJobs(query);

      jobs = data;
      _applyFilters();

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        hasError = true;
      });
    }
  }

  void _applyFilters() {
    filtered = jobs.where((j) {
      final matchPlatform =
          selectedPlatform == null || j.platform == selectedPlatform;

      final matchSearch =
          searchQuery.isEmpty ||
          j.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          j.company.toLowerCase().contains(searchQuery.toLowerCase());

      return matchPlatform && matchSearch;
    }).toList();

    setState(() {});
  }

  void onSearch(String q) {
    searchQuery = q;
    _applyFilters();
  }

  void onPlatform(String? p) {
    selectedPlatform = p;
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final platforms = jobs.map((e) => e.platform).toSet().toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            /// HEADER (same as fake UI)
            ElevateHeader(
              title: "${widget.niche} Jobs",
              subTitle: "Skill-verified positions worldwide",
              titleSize: 30,
              subtitleSize: 14,
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 50),
                child: Column(
                  children: [
                  // Padding remaining
                    IconText(
                      text: "Explore Jobs",
                      iconData: Icons.people_alt_outlined,
                      textSize: 20,
                      textWeight: FontWeight.bold,
                      iconSize: 25,
                      iconTextSpacing: 10,
                    ),

                    const SizedBox(height: 15),

                    /// SEARCH
                    CustomSearchBar(
                      hintText: "Search jobs...",
                      onChanged: onSearch,
                    ),

                    const SizedBox(height: 15),

                    /// PLATFORM FILTERS
                    if (jobs.isNotEmpty)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            PlatformFilterChip(
                              label: "All",
                              isSelected: selectedPlatform == null,
                              onTap: () => onPlatform(null),
                            ),
                            ...platforms.map(
                              (p) => PlatformFilterChip(
                                label: p,
                                isSelected: selectedPlatform == p,
                                onTap: () => onPlatform(p),
                              ),
                            ),
                          ],
                        ),
                      ),

                    /// JOB COUNT
                    if (!loading && !hasError)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${filtered.length} jobs found",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),

                    const SizedBox(height: 10),

                    /// BODY
                    Expanded(
                      child: hasError
                          ? _errorUI()
                          : loading
                          ? const Center(child: CircularProgressIndicator())
                          : filtered.isEmpty
                          ? const Center(child: Text("No jobs found"))
                          : ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (_, i) {
                                final job = filtered[i];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: JobCompactTile(
                                    title: job.title,
                                    company: job.company,
                                    location: job.location,
                                    isRemote: job.isRemote,
                                    jobType: job.jobType ?? "Full Time",
                                    salary: job.salary ?? "Not disclosed",
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              JobSelection(job: job),
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

  Widget _errorUI() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 50, color: Colors.grey),
          const SizedBox(height: 10),
          const Text("Failed to load jobs"),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: load, child: const Text("Retry")),
        ],
      ),
    );
  }
}*/
