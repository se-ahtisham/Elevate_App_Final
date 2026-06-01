import 'package:elevate_app/Custom_Widgets/Buttons/circle_icon_button.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/featured_job_card.dart';
import 'package:elevate_app/Custom_Widgets/Tiles/job_compact_tile.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/all_trending_skills.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/job_selection.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/other_platform_jobs.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/user_search_company.dart';
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
              _topHeader(context),

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

              TexxtButton(
                text: "Explore Companies",
                textSize: 13,
                textColor: Colors.black87,
                backgroundColor: const Color(0xFFE5E7EB),
                borderRadius: 20,
                height: 50,
                borderColor: const Color.fromARGB(255, 112, 112, 112),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserSearchCompany(),
                    ),
                  );
                },
              ),

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

  Widget _topHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: Color(0xFFE8E8E8),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const CustomText(
            text: 'A',
            fontSize: 36,
            color: ElevateColor.gray,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Let's Work,",
                fontSize: 13,
                color: Color(0xFF9A9A9A),
                fontWeight: FontWeight.w500,
              ),
              CustomText(
                text: 'Ahtisham Arshad',
                fontSize: 23,
                color: ElevateColor.gray,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
        CircleIconButton(
          iconData: Icons.inventory_2_outlined,
          iconSize: 20,
          iconColor: ElevateColor.gray,
          circleSize: 44,
          circleColor: ElevateColor.white,
          borderColor: const Color(0xFFE5E5E5),
          borderWidth: 1,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllTrendingSkillsScreen(),
              ),
            );
          },
          rippleColor: const Color(0x11000000),
        ),
      ],
    );
  }
}
