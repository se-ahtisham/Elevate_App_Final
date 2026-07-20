import 'package:elevate_app/Custom_Widgets/Buttons/circle_icon_button.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/all_trending_skills.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobScreenHeader extends ConsumerWidget {
  const JobScreenHeader({super.key});

  String getFirstLetter(String name) {
    if (name.trim().isEmpty) return "?";
    return name.trim()[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobSeeker = ref.watch(authProvider).jobSeeker;

    final name = jobSeeker?.name ?? "";
    final displayName = name.isNotEmpty ? name : "Job Seeker";
    final firstLetter = getFirstLetter(name);

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
          child: CustomText(
            text: firstLetter,
            fontSize: 36,
            color: ElevateColor.gray,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: "Let's Work,",
                fontSize: 13,
                color: Color(0xFF9A9A9A),
                fontWeight: FontWeight.w500,
              ),
              CustomText(
                text: displayName,
                fontSize: 23,
                color: ElevateColor.gray,
                fontWeight: FontWeight.w700,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
