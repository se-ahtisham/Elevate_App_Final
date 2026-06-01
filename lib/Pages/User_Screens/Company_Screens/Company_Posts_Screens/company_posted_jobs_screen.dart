import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Posts_Screens/company_upload_job_screen.dart';
import 'package:elevate_app/Pages/User_Screens/Company_Screens/Company_Posts_Screens/show_applied_candidates_screen.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class CompanyPostedJobsScreen extends StatefulWidget {
  const CompanyPostedJobsScreen({super.key});

  @override
  State<CompanyPostedJobsScreen> createState() =>
      _CompanyPostedJobsScreenState();
}

class _CompanyPostedJobsScreenState extends State<CompanyPostedJobsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  String _query = '';

  final List<Map<String, dynamic>> _allJobs = const [
    {
      'initials': 'MS',
      'title': 'UI/UX Designer',
      'company': 'Microsoft',
      'location': 'USA',
      'tags': ['Remote', 'Full Time', '600/mon'],
    },
    {
      'initials': 'GG',
      'title': 'Product Designer',
      'company': 'Google',
      'location': 'USA',
      'tags': ['Hybrid', 'Full Time', '800/mon'],
    },
    {
      'initials': 'AP',
      'title': 'Mobile Engineer',
      'company': 'Apple',
      'location': 'USA',
      'tags': ['Remote', 'Contract', '900/mon'],
    },
    {
      'initials': 'MS',
      'title': 'UI/UX Designer',
      'company': 'Microsoft',
      'location': 'USA',
      'tags': ['Remote', 'Full Time', '600/mon'],
    },
    {
      'initials': 'AD',
      'title': 'Visual Designer',
      'company': 'Adobe',
      'location': 'USA',
      'tags': ['Onsite', 'Full Time', '700/mon'],
    },
  ];

  List<Map<String, dynamic>> get _filteredJobs {
    final q = _query.trim().toLowerCase();

    if (q.isEmpty) return _allJobs;

    return _allJobs.where((j) {
      final title = (j['title'] as String).toLowerCase();
      final company = (j['company'] as String).toLowerCase();
      final location = (j['location'] as String).toLowerCase();
      final tags = (j['tags'] as List).join(' ').toLowerCase();

      return title.contains(q) ||
          company.contains(q) ||
          location.contains(q) ||
          tags.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),

          child: Column(
            children: [
              _topHeader(),

              const SizedBox(height: 18),

              _searchBar(),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Posted Jobs',
                  style: TextStyle(
                    color: ElevateColor.gray,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 30),

                  itemCount: _filteredJobs.length,

                  separatorBuilder: (_, _) => const SizedBox(height: 14),

                  itemBuilder: (_, index) {
                    final job = _filteredJobs[index];

                    return _jobCard(job);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topHeader() {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,

          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE7E7E7),
          ),

          alignment: Alignment.center,

          child: Text(
            'A',
            style: TextStyle(
              color: ElevateColor.gray,
              fontWeight: FontWeight.w700,
              fontSize: 32,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                "Let's Upload Opportunity",

                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9A9A9A),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'TechNova Inc.',

                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  fontSize: 22,
                  color: ElevateColor.gray,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        InkWell(
          child: Container(
            width: 46,
            height: 46,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              gradient: const LinearGradient(
                colors: [Color(0xFF555555), Color(0xFF111111)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.12),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: const Icon(
              Icons.ios_share_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CompanyUploadJobScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Container(
      height: 50,

      padding: const EdgeInsets.symmetric(horizontal: 14),

      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),

        borderRadius: BorderRadius.circular(30),

        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),

      child: Row(
        children: [
          const Icon(Icons.search_rounded, size: 21, color: Color(0xFF4D4D4D)),

          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: _searchCtrl,

              onChanged: (v) {
                setState(() {
                  _query = v;
                });
              },

              cursorColor: ElevateColor.gray,

              decoration: const InputDecoration(
                border: InputBorder.none,

                hintText: 'Search Post',

                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9A9A9A),
                  fontWeight: FontWeight.w500,
                ),
              ),

              style: const TextStyle(fontSize: 14, color: Color(0xFF4D4D4D)),
            ),
          ),

          if (_query.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchCtrl.clear();

                setState(() {
                  _query = '';
                });
              },

              child: const Icon(
                Icons.close_rounded,
                size: 18,
                color: Color(0xFF9A9A9A),
              ),
            ),
        ],
      ),
    );
  }

  Widget _jobCard(Map<String, dynamic> job) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(24),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.04),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Container(
                  width: 40,
                  height: 40,

                  decoration: const BoxDecoration(
                    color: Color(0xFF4A4A4A),
                    shape: BoxShape.circle,
                  ),

                  alignment: Alignment.center,

                  child: Text(
                    job['initials'],

                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        job['title'],

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: Color(0xFF2B2B2B),
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        '${job['company']}  •  ${job['location']}',

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF8B8B8B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 7,
                        runSpacing: 7,

                        children: (job['tags'] as List<String>)
                            .map(
                              (tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),

                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F3F3),

                                  borderRadius: BorderRadius.circular(30),
                                ),

                                child: Text(
                                  tag,

                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF777777),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        Container(
          width: 58,
          height: 108,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),

            gradient: const LinearGradient(
              colors: [Color(0xFF5B5B5B), Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.12),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),

          child: Material(
            color: Colors.transparent,

            child: InkWell(
              borderRadius: BorderRadius.circular(24),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowAppliedCandidatesScreen(),
                  ),
                );
              },

              child: const Center(
                child: Icon(
                  Icons.arrow_outward_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
