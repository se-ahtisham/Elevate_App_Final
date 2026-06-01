import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Jobs_Screens/Job_screen.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class UserApplyCompanyJob extends StatelessWidget {
  const UserApplyCompanyJob({super.key});

  static const double _pageHorizontal = 20;
  static const double _sectionGap = 18;
  static const double _labelToContentGap = 10;
  static const double _buttonGap = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElevateColor.white,
      body: Column(
        children: [
          const ElevateHeader(
            title: 'Grab Opportunity',
            subTitle: 'Go and Grab opportunity until its gone',
            titleSize: 30,
            subtitleSize: 13,
            titleLineHeight: 1.05,
            subtitleLineHeight: 3.2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  _pageHorizontal,
                  10,
                  _pageHorizontal,
                  20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your message',
                      style: TextStyle(
                        color: ElevateColor.gray,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: _labelToContentGap),
                    _MessageBox(),
                    const SizedBox(height: _sectionGap),
                    Text(
                      'Files',
                      style: TextStyle(
                        color: ElevateColor.gray,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: _labelToContentGap),
                    _FileTile(),
                    const SizedBox(height: _sectionGap),
                    _PrimaryButton(
                      title: 'Done',
                      icon: Icons.keyboard_arrow_down_rounded,
                      onTap: () {} /*() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => JobScreen()),
                        );
                      },*/,
                    ),
                    const SizedBox(height: _buttonGap),
                    _SecondaryButton(
                      title: 'Back',
                      icon: Icons.logout_rounded,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        border: Border.all(color: const Color(0xFFE2E2E2)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        'Thanks for Considering me for the UI/UX Designer '
        'position at Microsoft. I appreciate you sharing the '
        'details of the role and I am very excited about the '
        'opportunity to contribute to your team.\n\n'
        'With my experience in designing user-friendly interfaces and '
        'creating seamless user experiences for both web and mobile '
        'applications, I am confident in my ability to add value to your '
        'projects. I have worked extensively with tools like Figma, Adobe XD, '
        'and Sketch.\n\n'
        'I would love to learn more about your team, current projects, and '
        'how I can support your vision.',
        style: const TextStyle(
          fontSize: 12,
          height: 1.35,
          color: Color(0xFF454545),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _FileTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDCDCDC)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'CV.pdf',
            style: TextStyle(
              color: ElevateColor.gray,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: ElevateColor.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD8D8D8)),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.ios_share_rounded,
              size: 14,
              color: ElevateColor.lightgray,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: ElevateGradientColors.grayToBlack,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(11),
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: ElevateColor.white),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    color: ElevateColor.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SecondaryButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: Material(
        color: const Color(0xFFF5F5F5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
          side: const BorderSide(color: Color(0xFFBFBFBF)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(11),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: ElevateColor.lightgray),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: ElevateColor.lightgray,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
