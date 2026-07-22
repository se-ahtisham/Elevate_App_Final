import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Gradient_Colors/gradient_colors.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserApplyCompanyJob extends ConsumerStatefulWidget {
  final JobPostModel jobPost;
  final String coldEmail;

  const UserApplyCompanyJob({
    super.key,
    required this.jobPost,
    required this.coldEmail,
  });

  @override
  ConsumerState<UserApplyCompanyJob> createState() => _UserApplyCompanyJobState();
}

class _UserApplyCompanyJobState extends ConsumerState<UserApplyCompanyJob> {
  final _firebaseService = FirebaseService();
  late final TextEditingController _controller;
  bool _isApplying = false;

  static const double _pageHorizontal = 20;
  static const double _sectionGap = 18;
  static const double _labelToContentGap = 10;
  static const double _buttonGap = 10;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.coldEmail);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    final myID = ref.read(authProvider).jobSeeker?.jobSeekerID;
    if (myID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: User session not found.")),
      );
      return;
    }

    setState(() => _isApplying = true);
    try {
      await _firebaseService.applyJob(
        jobSeekerID: myID,
        jobID: widget.jobPost.jobID,
        coldEmail: _controller.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Application submitted successfully!")),
      );
      // Pop back twice to return to the jobs list
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
      );
    } finally {
      if (mounted) {
        setState(() => _isApplying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElevateColor.white,
      body: Column(
        children: [
          ElevateHeader(
            title: 'Grab Opportunity',
            subTitle: 'Go and Grab opportunity until its gone',
            titleSize: 30,
            subtitleSize: 13,
            titleLineHeight: 1.05,
            subtitleLineHeight: 3.2,
            showBackButton: true,
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
                    TextFormField(
                      controller: _controller,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        fillColor: const Color(0xFFFDFDFD),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E2E2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E2E2)),
                        ),
                        contentPadding: const EdgeInsets.all(14),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: Color(0xFF454545),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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
                    _isApplying
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: CircularProgressIndicator(color: Colors.black),
                            ),
                          )
                        : _PrimaryButton(
                            title: 'Done',
                            icon: Icons.keyboard_arrow_down_rounded,
                            onTap: _submitApplication,
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
