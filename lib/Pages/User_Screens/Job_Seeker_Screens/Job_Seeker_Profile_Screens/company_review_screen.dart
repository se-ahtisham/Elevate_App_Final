import 'dart:async';

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
  String? _errorMessage;
  String _processingStep = "Submitting review to AI NLP Model...";
  Timer? _stepTimer;

  // Only an Active employee of THIS company may submit a review.
  bool get _isActiveEmployee => _employment?.employeeStatus == 'Active';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
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

  void _startProcessingSteps() {
    _stepTimer?.cancel();
    int stepIndex = 0;
    final steps = [
      "Submitting review to AI NLP Model...",
      "Analyzing sentiment & extracting company strengths/weaknesses...",
      "Updating company profile & jobseeker review records on both sides...",
      "Finalizing AI model updates...",
    ];

    setState(() => _processingStep = steps[0]);

    _stepTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted || !_isSubmitting) {
        timer.cancel();
        return;
      }
      stepIndex = (stepIndex + 1) % steps.length;
      setState(() => _processingStep = steps[stepIndex]);
    });
  }

  void _copyToClipboard() {
    final text = _reviewController.text.trim();
    if (text.isEmpty) {
      _showSnack("Nothing to copy.");
      return;
    }
    Clipboard.setData(ClipboardData(text: text));
    _showSnack("Review text copied to clipboard!");
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      setState(() {
        _reviewController.text = data.text!;
      });
      _showSnack("Pasted from clipboard!");
    } else {
      _showSnack("Clipboard is empty.");
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
      _errorMessage = null;
    });

    _startProcessingSteps();

    try {
      await reviewApiService.submitReview(
        companyID: widget.companyID,
        companyName: widget.companyName,
        companyEmail: widget.companyEmail,
        jobSeekerID: widget.jobSeekerID,
        rawReview: text,
      );

      final review = ReviewModel(
        reviewID: FirebaseService.generateID(),
        companyID: widget.companyID,
        jobSeekerID: widget.jobSeekerID,
        text: text,
        createdAt: DateTime.now(),
      );
      await firebaseService.saveReview(review);

      _stepTimer?.cancel();
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _submitted = true;
      });
    } on ReviewApiException catch (e) {
      _stepTimer?.cancel();
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorMessage = e.message;
      });
      if (e.statusCode == 409) {
        _showSnack("You've already reviewed this company.");
        _loadInitialData();
      }
    } catch (e) {
      _stepTimer?.cancel();
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorMessage =
            "Failed to submit review to AI model. Please check network and try again.";
      });
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

  Widget _buildProcessingMessageBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 31, 31, 31),
            Color.fromARGB(255, 65, 65, 65),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const CustomText(
            text: "Processing Review with AI Model",
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            textAlign: TextAlign.center,
            lineHeight: 1.2,
          ),
          const SizedBox(height: 10),
          CustomText(
            text: _processingStep,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64B5F6),
            textAlign: TextAlign.center,
            lineHeight: 1.4,
          ),
          const SizedBox(height: 10),
          const CustomText(
            text:
                "Please wait ~15–30s while the AI NLP model processes your review and updates company insights.",
            fontSize: 11.5,
            color: Color(0xFFB0BEC5),
            textAlign: TextAlign.center,
            lineHeight: 1.4,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessageBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 55, 20, 20),
            Color.fromARGB(255, 90, 30, 30),
          ],
        ),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: 22,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: CustomText(
                  text: "Submission Issue",
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  lineHeight: 1.2,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.copy_rounded,
                  color: Colors.white70,
                  size: 20,
                ),
                tooltip: "Copy Review Text",
                onPressed: _copyToClipboard,
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomText(
            text: _errorMessage ?? "Failed to submit review to AI model.",
            fontSize: 12.5,
            color: const Color(0xFFFFCDD2),
            lineHeight: 1.4,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _submitReview,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    size: 18,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "Try Again",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: _copyToClipboard,
                icon: const Icon(
                  Icons.copy_rounded,
                  size: 16,
                  color: Colors.white,
                ),
                label: const Text(
                  "Copy Text",
                  style: TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CompanyBadge(logoPath: widget.logoPath, name: widget.companyName),
        const SizedBox(height: 24),

        if (_isSubmitting) _buildProcessingMessageBox(),

        if (!_isSubmitting && _errorMessage != null) _buildErrorMessageBox(),

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

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              text: "YOUR REVIEW",
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: ElevateColor.whitegray,
              lineHeight: 1.0,
            ),
            Row(
              children: [
                InkWell(
                  onTap: _copyToClipboard,
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.copy_rounded,
                          size: 14,
                          color: ElevateColor.gray,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Copy",
                          style: TextStyle(
                            fontSize: 11,
                            color: ElevateColor.gray,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _pasteFromClipboard,
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.content_paste_rounded,
                          size: 14,
                          color: ElevateColor.gray,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Paste",
                          style: TextStyle(
                            fontSize: 11,
                            color: ElevateColor.gray,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),

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
