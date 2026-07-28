import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/company_model.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:elevate_app/Database/Online_Database/firebase_storage_service.dart';
import 'package:elevate_app/Database/Online_Database/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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
  late final TextEditingController achievementsController;
  late final TextEditingController strengthsController;
  late final TextEditingController weaknessesController;

  static const _hintColor = Color(0xFF8E8E8E);
  static const _underlineColor = Color(0xFFE1E1E1);
  bool isSaving = false;
  File? selectedLogoImage;
  final picker = ImagePicker();
  final storageService = FirebaseStorageService();

  Future<void> pickLogoImage() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null && mounted) {
      final file = File(picked.path);
      if (!storageService.validateFileSize(file, context)) {
        return;
      }
      setState(() {
        selectedLogoImage = file;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    aboutController = TextEditingController(text: widget.company.description);
    locationController = TextEditingController(text: widget.company.location);
    emailController = TextEditingController(text: widget.company.email);
    websiteController = TextEditingController(text: widget.company.website);
    achievementsController = TextEditingController(text: widget.company.achievementList.join(', '));
    strengthsController = TextEditingController(text: widget.company.companyStrengthList.join(', '));
    weaknessesController = TextEditingController(text: widget.company.companyWeaknessList.join(', '));
  }

  @override
  void dispose() {
    aboutController.dispose();
    locationController.dispose();
    emailController.dispose();
    websiteController.dispose();
    achievementsController.dispose();
    strengthsController.dispose();
    weaknessesController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => isSaving = true);
    try {
      String? uploadedLogoUrl;
      final userId = AuthService().currentUser?.uid ?? widget.company.companyID;
      if (selectedLogoImage != null && userId.isNotEmpty) {
        uploadedLogoUrl = await storageService.uploadProfileImage(
          userId: userId,
          file: selectedLogoImage!,
          context: context,
        );
      }

      final updateData = {
        'description': aboutController.text.trim(),
        'location': locationController.text.trim(),
        'email': emailController.text.trim(),
        'website': websiteController.text.trim(),
        'achievementList': achievementsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        'companyStrengthList': strengthsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        'companyWeaknessList': weaknessesController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      };
      if (uploadedLogoUrl != null) {
        updateData['logo'] = uploadedLogoUrl;
      }

      await FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.company.companyID)
          .update(updateData);
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

                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: pickLogoImage,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: selectedLogoImage != null
                                    ? FileImage(selectedLogoImage!)
                                    : (widget.company.logo.isNotEmpty
                                            ? NetworkImage(widget.company.logo)
                                            : null)
                                        as ImageProvider?,
                                child:
                                    selectedLogoImage == null &&
                                        widget.company.logo.isEmpty
                                    ? Text(
                                        widget.company.companyName.isNotEmpty
                                            ? widget.company.companyName[0].toUpperCase()
                                            : "?",
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      )
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.center,
                        child: CustomText(
                          text: "Tap to change logo",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: ElevateColor.gray,
                        ),
                      ),
                      const SizedBox(height: 30),

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

                      CustomTextField(
                        hintText: "Achievements (comma separated)",
                        hintWeight: FontWeight.w700,
                        hintColor: _hintColor,
                        controller: achievementsController,
                        cursorColor: ElevateColor.gray,
                        underlineColor: _underlineColor,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      
                      const SizedBox(height: 30),

                      CustomTextField(
                        hintText: "Company Strengths (comma separated)",
                        hintWeight: FontWeight.w700,
                        hintColor: _hintColor,
                        controller: strengthsController,
                        cursorColor: ElevateColor.gray,
                        underlineColor: _underlineColor,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),

                      const SizedBox(height: 30),

                      CustomTextField(
                        hintText: "Company Weaknesses (comma separated)",
                        hintWeight: FontWeight.w700,
                        hintColor: _hintColor,
                        controller: weaknessesController,
                        cursorColor: ElevateColor.gray,
                        underlineColor: _underlineColor,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
