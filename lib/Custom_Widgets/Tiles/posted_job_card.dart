import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class PostedJobCard extends StatelessWidget {
  final String initials;
  final String title;
  final String companyAndLocation;
  final List<String> tags;
  final VoidCallback? onTap;
  final bool isSelected;

  const PostedJobCard({
    super.key,
    this.initials = 'MS',
    this.title = 'UI/UX Designer',
    this.companyAndLocation = 'Microsoft  •  USA',
    this.tags = const ['Remote', 'Full Time', '600/mon'],
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? const Color(0xFF2F6BFF) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 6, 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: ElevateColor.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4A4A4A),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: ElevateColor.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13.2,
                                color: ElevateColor.gray,
                                fontWeight: FontWeight.w600,
                                height: 1.0,
                              ),
                            ),
                            Text(
                              companyAndLocation,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 9,
                                color: Color(0xFF9A9A9A),
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (int i = 0; i < tags.length; i++) ...[
                        _Tag(text: tags[i]),
                        if (i != tags.length - 1) const SizedBox(width: 6),
                      ],
                    ],
                  ),
                ],
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onTap,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(14),
              bottomRight: Radius.circular(14),
            ),
            child: Ink(
              width: 58,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: ElevateGradientColors.grayToBlack,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
              child: const Center(
                child: SizedBox(
                  width: 26,
                  height: 26,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: Color(0xFFD8D8D8), width: 1.1),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_outward_rounded,
                        color: ElevateColor.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;

  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4.5),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 8.5,
          color: Color(0xFF767676),
          fontWeight: FontWeight.w500,
          height: 1.0,
        ),
      ),
    );
  }
}
