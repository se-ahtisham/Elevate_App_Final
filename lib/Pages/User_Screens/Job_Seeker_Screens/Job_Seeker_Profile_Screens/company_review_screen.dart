import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/review_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CompanyReviewScreen extends StatefulWidget {
  final String companyID;
  final String companyName;
  final String jobSeekerID;
  final String logoPath;

  const CompanyReviewScreen({
    super.key,
    required this.companyID,
    required this.companyName,
    required this.jobSeekerID,
    this.logoPath = '',
  });

  @override
  State<CompanyReviewScreen> createState() => _CompanyReviewScreenState();
}

class _CompanyReviewScreenState extends State<CompanyReviewScreen> {
  final firebaseService = FirebaseService();
  final TextEditingController _reviewController = TextEditingController();

  ReviewModel? _existingReview;
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _checkExistingReview();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _checkExistingReview() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final existing = await firebaseService.getReviewForSeekerAndCompany(
        widget.companyID,
        widget.jobSeekerID,
      );

      if (!mounted) return;
      setState(() {
        _existingReview = existing;
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

    setState(() => _isSubmitting = true);

    try {
      final review = ReviewModel(
        reviewID: FirebaseService.generateID(),
        companyID: widget.companyID,
        jobSeekerID: widget.jobSeekerID,
        rating: 5.0,
        text: text,
        sentiment: 'Positive',
        createdAt: DateTime.now(),
      );

      await firebaseService.submitEmployeeReview(review);

      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _submitted = true;
      });
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
            // ── Header ────────────────────────────────────────
            ElevateHeader(
              title: "Write a Review",
              subTitle: widget.companyName,
              titleSize: 24,
              subtitleSize: 14,
              showBackButton: true,
            ),

            // ── Content ───────────────────────────────────────
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

  // ── Already submitted state ──────────────────────────────────
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
        _OutlineButton(
          label: "Go Back",
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }

  // ── Success state after submitting ───────────────────────────
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
        _OutlineButton(
          label: "Go Back",
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }

  // ── Main review form ──────────────────────────────────────────
  Widget _buildReviewForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company badge
        _CompanyBadge(logoPath: widget.logoPath, name: widget.companyName),
        const SizedBox(height: 28),

        // Section label
        const CustomText(
          text: "YOUR REVIEW",
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: ElevateColor.whitegray,
          lineHeight: 1.0,
        ),
        const SizedBox(height: 10),

        // ── Dark gradient text box ────────────────────────────
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

        // Hint
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

        // ── Submit button ─────────────────────────────────────
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitReview,
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
        _OutlineButton(
          label: "Cancel",
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

// ── Company badge header ─────────────────────────────────────────
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
      child:
          const Icon(Icons.business_outlined, size: 30, color: Colors.black54),
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

// ── Outline cancel / back button ─────────────────────────────────
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
