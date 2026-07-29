import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/review_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_employee_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Profile_Screens/review_api_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CompanyReviewScreen extends StatefulWidget {
  final String companyID;
  final String companyName;
  final String jobSeekerID;
  final String logoPath;

  // Needed for the API call — company_email is required by the backend.
  final String companyEmail;

  const CompanyReviewScreen({
    super.key,
    required this.companyID,
    required this.companyName,
    required this.jobSeekerID,
    required this.companyEmail,
    this.logoPath = '',
  });

  @override
  State<CompanyReviewScreen> createState() => _CompanyReviewScreenState();
}

class _CompanyReviewScreenState extends State<CompanyReviewScreen> {
  final firebaseService = FirebaseService();
  final reviewApiService = ReviewApiService();
  final TextEditingController _reviewController = TextEditingController();

  ReviewModel? _existingReview;
  CompanyEmployeeModel? _employment; // this job seeker's record at this company
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _submitted = false;

  // Only an Active employee of THIS company may submit a review.
  bool get _isActiveEmployee => _employment?.employeeStatus == 'Active';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // Run both checks: does a review already exist, and is this job
      // seeker an active employee of this company.
      final results = await Future.wait([
        firebaseService.getReviewForSeekerAndCompany(
          widget.companyID,
          widget.jobSeekerID,
        ),
        firebaseService.getEmployeesForJobSeeker(widget.jobSeekerID),
      ]);

      final existing = results[0] as ReviewModel?;
      final employments = results[1] as List<CompanyEmployeeModel>;

      CompanyEmployeeModel? employment;
      for (final e in employments) {
        if (e.companyID == widget.companyID) {
          employment = e;
          break;
        }
      }

      if (!mounted) return;
      setState(() {
        _existingReview = existing;
        _employment = employment;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _submitReview() async {
    final text = _reviewController.text.trim();
    if (text.isEmpty) {
      _showSnack("Please write your review before submitting.");
      return;
    }
    if (!_isActiveEmployee) {
      _showSnack("Only active employees of this company can leave a review.");
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Call AI NLP backend — returns strengths/weaknesses derived from the review.
      final apiResult = await reviewApiService.submitReview(
        companyID: widget.companyID,
        companyName: widget.companyName,
        companyEmail: widget.companyEmail,
        jobSeekerID: widget.jobSeekerID,
        rawReview: text,
      );

      // ── Write strengths/weaknesses to Firestore immediately ──────────────
      // The backend returns aspect lists; extract them and save to the company
      // document so CompanyProfile displays them correctly.
      try {
        debugPrint('[Review] API response keys: ${apiResult.keys.toList()}');
        debugPrint('[Review] raw company_strengths: ${apiResult['company_strengths']}');
        debugPrint('[Review] companyID for Firestore: ${widget.companyID}');

        final rawStrengths = apiResult['company_strengths'] as List<dynamic>? ?? [];
        final rawWeaknesses = apiResult['company_weaknesses'] as List<dynamic>? ?? [];

        // Convert aspect maps → human-readable labels
        final Map<String, String> aspectLabels = {
          'innovation_creativity': 'Innovation & Creativity',
          'team_culture': 'Team Culture',
          'management': 'Management',
          'growth': 'Growth Opportunities',
          'recognition': 'Employee Recognition',
          'work_life_balance': 'Work-Life Balance',
          'compensation': 'Compensation & Benefits',
          'communication': 'Communication',
          'diversity': 'Diversity & Inclusion',
          'job_security': 'Job Security',
          'overworked': 'Overworked',
          'poor_management': 'Poor Management',
          'lack_of_growth': 'Lack of Growth',
          'poor_communication': 'Poor Communication',
          'toxic_culture': 'Toxic Culture',
        };

        List<String> strengthLabels = rawStrengths
            .whereType<Map>()
            .map((s) {
              final aspect = s['aspect']?.toString() ?? '';
              return aspectLabels[aspect] ?? aspect.replaceAll('_', ' ').toUpperCase();
            })
            .where((s) => s.isNotEmpty)
            .toList();

        List<String> weaknessLabels = rawWeaknesses
            .whereType<Map>()
            .map((s) {
              final aspect = s['aspect']?.toString() ?? '';
              return aspectLabels[aspect] ?? aspect.replaceAll('_', ' ').toUpperCase();
            })
            .where((s) => s.isNotEmpty)
            .toList();

        debugPrint('[Review] strengthLabels=$strengthLabels weaknessLabels=$weaknessLabels');

        await firebaseService.db
            .collection('companies')
            .doc(widget.companyID)
            .update({
          if (strengthLabels.isNotEmpty) 'companyStrengthList': strengthLabels,
          if (weaknessLabels.isNotEmpty) 'companyWeaknessList': weaknessLabels,
        });
        debugPrint('[Review] ✅ Firestore updated for company=${widget.companyID} '
            'strengths=$strengthLabels weaknesses=$weaknessLabels');
      } catch (e, st) {
        debugPrint('[Review] ⚠️ Firestore strength/weakness write failed: $e\n$st');
        // Non-critical — will retry on next review submission.
      }

      // Save lightweight ReviewModel locally so "already reviewed" guard works.
      final review = ReviewModel(
        reviewID: FirebaseService.generateID(),
        companyID: widget.companyID,
        jobSeekerID: widget.jobSeekerID,
        text: text,
        createdAt: DateTime.now(),
      );
      await firebaseService.saveReview(review);

      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _submitted = true;
      });
    } on ReviewApiException catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      if (e.statusCode == 409) {
        // Backend says a review already exists — refresh local state so
        // the "already reviewed" screen shows instead of the form.
        _showSnack("You've already reviewed this company.");
        _loadInitialData();
      } else {
        _showSnack(e.message);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      _showSnack("Failed to submit review. Please try again.");
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: ElevateColor.gray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            ElevateHeader(
              title: "Write a Review",
              subTitle: widget.companyName,
              titleSize: 24,
              subtitleSize: 14,
              showBackButton: true,
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 28,
                      ),
                      child: _existingReview != null && !_submitted
                          ? _buildAlreadyReviewed()
                          : _submitted
                          ? _buildSuccessState()
                          : _buildReviewForm(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlreadyReviewed() {
    final existing = _existingReview!;

    return Column(
      children: [
        _CompanyBadge(logoPath: widget.logoPath, name: widget.companyName),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 31, 31, 31),
                Color.fromARGB(255, 65, 65, 65),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF81C784),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  CustomText(
                    text: "Review Already Submitted",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    lineHeight: 1.2,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              CustomText(
                text: existing.text,
                fontSize: 13,
                color: const Color(0xFFCCCCCC),
                lineHeight: 1.6,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _OutlineButton(label: "Go Back", onTap: () => Navigator.pop(context)),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: 90,
          height: 90,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF2E2E2E), Color(0xFF555555)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 46),
        ),
        const SizedBox(height: 24),
        const CustomText(
          text: "Review Submitted!",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: ElevateColor.gray,
          lineHeight: 1.2,
        ),
        const SizedBox(height: 10),
        CustomText(
          text:
              "Thank you for sharing your experience\nwith ${widget.companyName}.",
          fontSize: 13,
          color: ElevateColor.whitegray,
          textAlign: TextAlign.center,
          lineHeight: 1.6,
        ),
        const SizedBox(height: 32),
        _OutlineButton(label: "Go Back", onTap: () => Navigator.pop(context)),
      ],
    );
  }

  Widget _buildReviewForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CompanyBadge(logoPath: widget.logoPath, name: widget.companyName),
        const SizedBox(height: 28),

        // ── Employment-required notice ──────────────────────────
        if (!_isActiveEmployee) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFCC80)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFFEF6C00),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomText(
                    text: _employment == null
                        ? "Only active employees of ${widget.companyName} can leave a review. You don't have an employment record with this company."
                        : "Your employment status with ${widget.companyName} is '${_employment!.employeeStatus}'. Only active employees can leave a review.",
                    fontSize: 12.5,
                    color: const Color(0xFFEF6C00),
                    lineHeight: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],

        const CustomText(
          text: "YOUR REVIEW",
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: ElevateColor.whitegray,
          lineHeight: 1.0,
        ),
        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 31, 31, 31),
                Color.fromARGB(255, 65, 65, 65),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: TextField(
            controller: _reviewController,
            enabled: _isActiveEmployee,
            maxLines: 7,
            minLines: 6,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.6,
            ),
            decoration: InputDecoration(
              hintText:
                  "Share your experience working at ${widget.companyName}...",
              hintStyle: const TextStyle(
                color: Color(0xFF9E9E9E),
                fontSize: 13,
                height: 1.5,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(height: 10),

        const Align(
          alignment: Alignment.centerRight,
          child: CustomText(
            text: "Be honest, Be helpful",
            fontSize: 11,
            color: ElevateColor.whitegray,
            lineHeight: 1.0,
          ),
        ),
        const SizedBox(height: 30),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: (_isSubmitting || !_isActiveEmployee)
                ? null
                : _submitReview,
            style: ElevatedButton.styleFrom(
              backgroundColor: ElevateColor.gray,
              disabledBackgroundColor: const Color(0xFFBDBDBD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const CustomText(
                    text: "Submit Review",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    lineHeight: 1.0,
                  ),
          ),
        ),
        const SizedBox(height: 14),
        _OutlineButton(label: "Cancel", onTap: () => Navigator.pop(context)),
      ],
    );
  }
}

class _CompanyBadge extends StatelessWidget {
  final String logoPath;
  final String name;

  const _CompanyBadge({required this.logoPath, required this.name});

  @override
  Widget build(BuildContext context) {
    final Widget fallback = Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE8E8E8),
      ),
      child: const Icon(
        Icons.business_outlined,
        size: 30,
        color: Colors.black54,
      ),
    );

    return Row(
      children: [
        ClipOval(
          child: logoPath.startsWith('http')
              ? Image.network(
                  logoPath,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => fallback,
                )
              : logoPath.isNotEmpty
              ? Image.asset(
                  logoPath,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => fallback,
                )
              : fallback,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: name,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ElevateColor.gray,
                lineHeight: 1.2,
              ),
              const SizedBox(height: 4),
              const CustomText(
                text: "Share your experience",
                fontSize: 12,
                color: ElevateColor.whitegray,
                lineHeight: 1.2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OutlineButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: ElevateColor.gray, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: CustomText(
          text: label,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: ElevateColor.gray,
          lineHeight: 1.0,
        ),
      ),
    );
  }
}
