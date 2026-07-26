import 'dart:io';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/job_post_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Database/Online_Database/firebase_storage_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:file_picker/file_picker.dart';
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
  ConsumerState<UserApplyCompanyJob> createState() =>
      UserApplyCompanyJobState();
}

class UserApplyCompanyJobState extends ConsumerState<UserApplyCompanyJob> {
  final firebaseService = FirebaseService();
  final storageService = FirebaseStorageService();

  late final TextEditingController controller;
  bool isApplying = false;

  File? selectedResumeFile;
  String? selectedResumeFileName;

  static const double pageHorizontal = 20;
  static const double sectionGap = 18;
  static const double labelToContentGap = 10;
  static const double buttonGap = 10;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.coldEmail);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> pickResumeFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
    );

    if (result != null && result.files.single.path != null && mounted) {
      final file = File(result.files.single.path!);

      // Validate file size < 100 KB
      if (!storageService.validateFileSize(file, context)) {
        return;
      }

      setState(() {
        selectedResumeFile = file;
        selectedResumeFileName = result.files.single.name;
      });
    }
  }

  void removeResumeFile() {
    setState(() {
      selectedResumeFile = null;
      selectedResumeFileName = null;
    });
  }

  Future<void> submitApplication() async {
    final myID = ref.read(authProvider).jobSeeker?.jobSeekerID;
    if (myID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: User session not found.")),
      );
      return;
    }

    setState(() => isApplying = true);
    try {
      String? resumeUrl;

      // Upload resume to Firebase Storage if selected
      if (selectedResumeFile != null) {
        resumeUrl = await storageService.uploadResumeFile(
          userId: myID,
          file: selectedResumeFile!,
          context: context,
        );
      }

      await firebaseService.applyJob(
        jobSeekerID: myID,
        jobID: widget.jobPost.jobID,
        coldEmail: controller.text,
        resumeUrl: resumeUrl ?? '',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resumeUrl != null
                ? "Application with resume submitted successfully!"
                : "Application submitted successfully!",
          ),
        ),
      );

      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
      );
    } finally {
      if (mounted) {
        setState(() => isApplying = false);
      }
    }
  }

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
            showBackButton: true,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  pageHorizontal,
                  10,
                  pageHorizontal,
                  20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your message',
                      style: TextStyle(
                        color: ElevateColor.gray,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: labelToContentGap),
                    TextFormField(
                      controller: controller,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        fillColor: const Color(0xFFFDFDFD),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E2E2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE2E2E2),
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(14),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: Color(0xFF454545),
                      ),
                    ),
                    const SizedBox(height: sectionGap),

                    // Resume Document Attachment Section (< 100 KB)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Attach Resume / CV (< 1MB)',
                          style: TextStyle(
                            color: ElevateColor.gray,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.black,
                          ),
                          onPressed: pickResumeFile,
                        ),
                      ],
                    ),
                    if (selectedResumeFileName != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.description,
                              size: 20,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                selectedResumeFileName!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: removeResumeFile,
                              child: const Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      const Text(
                        "No resume file selected (optional)",
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),

                    const SizedBox(height: sectionGap * 1.5),

                    isApplying
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : Column(
                            children: [
                              GestureDetector(
                                onTap: submitApplication,
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF595959),
                                        Color(0xFF111111),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'SUBMIT APPLICATION',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: buttonGap),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: ElevateColor.gray,
                                      width: 1,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'CANCEL',
                                      style: TextStyle(
                                        color: ElevateColor.gray,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
