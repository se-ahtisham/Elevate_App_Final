import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Text_background_box/custom_text_box.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class FeaturedJobCard extends StatelessWidget {
  final String initials;
  final String title;
  final String companyAndLocation;
  final String description;
  final String jobMode;
  final String jobType;
  final String salary;
  final String actionText;
  final VoidCallback? onApplyTap;

  const FeaturedJobCard({
    super.key,
    required this.initials,
    required this.title,
    required this.companyAndLocation,
    required this.description,
    this.jobMode = 'Remote',
    this.jobType = 'Full Time',
    this.salary = '600 / mon',
    this.actionText = 'APPLY NOW',
    this.onApplyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF3D3D3D), Color(0xFF0E0E0E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x38000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      // SingleChildScrollView wraps the whole content so that if the
      // available height is ever smaller than what the content needs
      // (small screens, large text scale factor, keyboard open, etc.)
      // the card scrolls internally instead of throwing a
      // RenderFlex overflow error.
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            // Avatar + title + company/location row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: CustomText(
                    text: initials,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: ElevateColor.gray,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: title,
                        fontSize: 13,
                        color: ElevateColor.white,
                        fontWeight: FontWeight.w700,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      CustomText(
                        text: companyAndLocation,
                        fontSize: 10,
                        color: const Color(0xFFC0C0C0),
                        fontWeight: FontWeight.w400,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            CustomText(
              text: description,
              fontSize: 9,
              color: const Color(0xFFB4B4B4),
              fontWeight: FontWeight.w400,
              lineHeight: 1.3,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),
            const Divider(color: Color(0xFF565656), thickness: 0.7, height: 1),
            const SizedBox(height: 8),

            // Mode / type / salary chips — scrolls horizontally so long
            // text (like longer salary strings) never overflows the card
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Row(
                children: [
                  CustomTextBox(
                    text: jobMode,
                    textSize: 9,
                    textColor: const Color(0xFFCBCBCB),
                    textWeight: FontWeight.w500,
                    height: 22,
                    paddingLeft: 12,
                    paddingRight: 12,
                    backgroundColor: const Color(0x00111111),
                    borderColor: const Color(0xFF5E5E5E),
                    borderWidth: 0.8,
                    borderRadius: 18,
                  ),
                  const SizedBox(width: 8),
                  CustomTextBox(
                    text: jobType,
                    textSize: 9,
                    textColor: const Color(0xFFCBCBCB),
                    textWeight: FontWeight.w500,
                    height: 22,
                    paddingLeft: 12,
                    paddingRight: 12,
                    backgroundColor: const Color(0x00111111),
                    borderColor: const Color(0xFF5E5E5E),
                    borderWidth: 0.8,
                    borderRadius: 18,
                  ),
                  const SizedBox(width: 8),
                  CustomTextBox(
                    text: salary,
                    textSize: 9,
                    textColor: const Color(0xFFCBCBCB),
                    textWeight: FontWeight.w500,
                    height: 22,
                    paddingLeft: 12,
                    paddingRight: 12,
                    backgroundColor: const Color(0x00111111),
                    borderColor: const Color(0xFF5E5E5E),
                    borderWidth: 0.8,
                    borderRadius: 18,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 28,
              child: ElevatedButton(
                onPressed: onApplyTap,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: ElevateColor.white,
                  foregroundColor: ElevateColor.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: CustomText(
                  text: actionText,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: ElevateColor.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
