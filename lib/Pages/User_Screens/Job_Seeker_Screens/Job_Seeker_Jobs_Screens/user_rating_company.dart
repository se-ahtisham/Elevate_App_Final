import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/review_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRatingCompany extends ConsumerStatefulWidget {
  final CompanyModel company;

  const UserRatingCompany({super.key, required this.company});

  @override
  ConsumerState<UserRatingCompany> createState() => _UserRatingCompanyState();
}

class _UserRatingCompanyState extends ConsumerState<UserRatingCompany> {
  final _firebaseService = FirebaseService();
  final _textController = TextEditingController();
  double _rating = 5.0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    final myID = ref.read(authProvider).jobSeeker?.jobSeekerID;
    if (myID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: User session not found.")),
      );
      return;
    }

    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please write some feedback before submitting."),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final review = ReviewModel(
        reviewID: FirebaseService.generateID(),
        companyID: widget.company.companyID,
        jobSeekerID: myID,
        rating: _rating,
        text: _textController.text.trim(),
        sentiment: _rating >= 4.0
            ? "Positive"
            : _rating <= 2.0
            ? "Negative"
            : "Neutral",
        createdAt: DateTime.now(),
      );

      await _firebaseService.submitEmployeeReview(review);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback submitted successfully!")),
      );

      // Pop back three times to return to the company details/list
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit feedback: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElevateColor.white,
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevateHeader(
              title: "Tell The Truth",
              subTitle: "Don’t worries you are save :)",
              titleSize: 25,
              subtitleSize: 20,
              showBackButton: true,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const CustomText(
                      text: "Your Feedback",
                      fontSize: 19,
                      color: Color.fromARGB(255, 99, 99, 99),
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.justify,
                      maxLines: 2,
                      lineHeight: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),

                    // Star Rating Picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(5, (index) {
                        final starValue = index + 1.0;
                        return IconButton(
                          icon: Icon(
                            starValue <= _rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 36,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = starValue;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: _textController,
                      maxLines: 8,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText:
                            "Tell us about your experience with ${widget.company.companyName}...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFDCDCDC),
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 99, 99, 99),
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),

                    _isSubmitting
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : TextButtonGradient(
                            text: "Done",
                            height: 50,
                            textSize: 14,
                            textWeight: FontWeight.w400,
                            borderRadius: 50,
                            onTap: _submitFeedback,
                          ),
                    const SizedBox(height: 15),
                    TexxtButton(
                      text: "Back",
                      height: 50,
                      textSize: 14,
                      textColor: ElevateColor.gray,
                      textWeight: FontWeight.w400,
                      borderRadius: 50,
                      backgroundColor: Colors.transparent,
                      borderColor: ElevateColor.gray,
                      borderWidth: 1,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
