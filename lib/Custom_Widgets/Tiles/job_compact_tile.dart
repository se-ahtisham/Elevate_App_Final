import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:flutter/material.dart';

class JobCompactTile extends StatelessWidget {
  final String title;
  final String company;
  final String location;
  final bool isRemote;
  final String jobType; // Full Time / Part Time / Internship
  final String salary;
  final VoidCallback? onTap;

  const JobCompactTile({
    super.key,
    required this.title,
    required this.company,
    required this.location,
    required this.isRemote,
    required this.jobType,
    required this.salary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    List<String> tags = [if (isRemote) "Remote", jobType, salary];

    return SizedBox(
      height: 95,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE
                      CustomText(
                        text: title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),

                      const SizedBox(height: 2),

                      /// COMPANY + LOCATION
                      CustomText(
                        text: "$company · $location",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 11.5,
                        color: Color(0xFF8C8C8C),
                      ),

                      const SizedBox(height: 8),

                      /// TAGS
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0; i < tags.length; i++) ...[
                              _buildTag(tags[i]),
                              if (i != tags.length - 1)
                                const SizedBox(width: 6),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// ARROW BUTTON
              InkWell(
                onTap: onTap,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
                child: Container(
                  width: 55,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6B6B6B), Color(0xFF111111)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6F6F6F),
        ),
      ),
    );
  }
}
