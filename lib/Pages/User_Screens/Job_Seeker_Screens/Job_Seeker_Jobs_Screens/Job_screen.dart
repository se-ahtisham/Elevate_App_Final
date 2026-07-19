import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/featured_job_card.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_compact_tile.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_header.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/other_platform_jobs.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class JobScreen extends StatelessWidget {
  final String niche;
  final String experience;

  const JobScreen({super.key, required this.niche, required this.experience});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
 Image.asset(
                "lib/Animation/Welcome.gif",
                width: 150,
                height: 50,
                fit: BoxFit.contain,
              ),
                const SizedBox(height: 15),
              const JobScreenHeader(),

              const SizedBox(height: 30),

              const CustomText(
                text: 'Recommended Jobs',
                fontSize: 18,
                color: ElevateColor.gray,
                fontWeight: FontWeight.w700,
              ),

              const SizedBox(height: 10),

              FeaturedJobCard(
                initials: 'MS',
                title: 'SOFTWARE ENGINEER',
                companyAndLocation: 'Microsoft  •  USA',
                description:
                    'Strong skills in programming, debugging, and building efficient software solutions.',
                onApplyTap: () {},
              ),

              const SizedBox(height: 30),

              const SizedBox(height: 30),

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
                          builder: (context) => OtherPlatformJobs(
                            niche: niche,
                            experience: experience,
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

              JobCompactTile(
                title: 'UI/UX Designer',
                company: 'Microsoft',
                location: 'USA',
                salary: "600",
                isRemote: true,
                jobType: "Full Time",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Open job details')),
                  );
                },
              ),

              const SizedBox(height: 10),

              JobCompactTile(
                title: 'UI/UX Designer',
                company: 'Microsoft',
                location: 'USA',
                salary: "600",
                isRemote: true,
                jobType: "Full Time",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Open job details')),
                  );
                },
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
