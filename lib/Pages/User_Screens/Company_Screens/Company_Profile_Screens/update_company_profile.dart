import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateCompanyProfile extends StatefulWidget {
  final CompanyModel company;
  const UpdateCompanyProfile({super.key, required this.company});

  @override
  State<UpdateCompanyProfile> createState() => _UpdateCompanyProfileState();
}

class _UpdateCompanyProfileState extends State<UpdateCompanyProfile> {
  late final TextEditingController aboutController;
  late final TextEditingController locationController;
  late final TextEditingController emailController;
  late final TextEditingController websiteController;

  static const _hintColor = Color(0xFF8E8E8E);
  static const _underlineColor = Color(0xFFE1E1E1);
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    aboutController = TextEditingController(text: widget.company.description);
    locationController = TextEditingController(text: widget.company.location);
    emailController = TextEditingController(text: widget.company.email);
    websiteController = TextEditingController(text: widget.company.website);
  }

  @override
  void dispose() {
    aboutController.dispose();
    locationController.dispose();
    emailController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => isSaving = true);
    try {
      await FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.company.companyID)
          .update({
        'description': aboutController.text.trim(),
        'location': locationController.text.trim(),
        'email': emailController.text.trim(),
        'website': websiteController.text.trim(),
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            ElevateHeader(
              title: "Smarter Way to Grow",
              subTitle: "Your journey to success starts here",
              titleSize: 30,
              subtitleSize: 13,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 6),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      CustomTextField(
                        hintText: "About us",
                        hintWeight: FontWeight.w700,
                        hintColor: _hintColor,
                        controller: aboutController,
                        cursorColor: ElevateColor.gray,
                        underlineColor: _underlineColor,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),

                      const SizedBox(height: 30),

                      CustomTextField(
                        hintText: "Location",
                        hintWeight: FontWeight.w700,
                        hintColor: _hintColor,
                        controller: locationController,
                        cursorColor: ElevateColor.gray,
                        underlineColor: _underlineColor,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),

                      const SizedBox(height: 30),

                      CustomTextField(
                        hintText: "Email",
                        hintWeight: FontWeight.w700,
                        hintColor: _hintColor,
                        controller: emailController,
                        cursorColor: ElevateColor.gray,
                        underlineColor: _underlineColor,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),

                      const SizedBox(height: 30),

                      CustomTextField(
                        hintText: "Website",
                        hintWeight: FontWeight.w700,
                        hintColor: _hintColor,
                        controller: websiteController,
                        cursorColor: ElevateColor.gray,
                        underlineColor: _underlineColor,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),

                      const SizedBox(height: 30),

                      CustomText(
                        text: "Company Achievements",
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: ElevateColor.lightgray,
                        lineHeight: 1.0,
                        textAlign: TextAlign.left,
                      ),

                      const SizedBox(height: 12),

                      if (widget.company.achievementList.isNotEmpty)
                        Container(
                          width: double.infinity,
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 232, 232, 232),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: const Color.fromARGB(255, 210, 210, 210),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.emoji_events_outlined,
                                size: 18,
                                color: ElevateColor.lightgray,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomText(
                                  text: widget.company.achievementList.join(", "),
                                  fontSize: 11,
                                  color: ElevateColor.lightgray,
                                  fontWeight: FontWeight.w400,
                                  lineHeight: 1.2,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 18),

                      TextButtonGradient(
                        text: isSaving ? "SAVING..." : "UPDATE NOW",
                        height: 50,
                        textSize: 12,
                        textWeight: FontWeight.w600,
                        borderRadius: 50,
                        borderColor: Colors.transparent,
                        borderWidth: 0,
                        width: double.infinity,
                        onTap: isSaving ? null : _saveProfile,
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
