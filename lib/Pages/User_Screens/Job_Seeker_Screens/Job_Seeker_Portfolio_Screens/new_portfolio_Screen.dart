import 'dart:io';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/project_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Database/Online_Database/firebase_storage_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class NewPortfolioScreen extends ConsumerStatefulWidget {
  const NewPortfolioScreen({super.key});

  @override
  ConsumerState<NewPortfolioScreen> createState() => NewPortfolioScreenState();
}

class NewPortfolioScreenState extends ConsumerState<NewPortfolioScreen> {
  final firebaseService = FirebaseService();
  final storageService = FirebaseStorageService();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final imagesNotifier = ValueNotifier<List<File>>([]);
  final filesNotifier = ValueNotifier<List<PlatformFile>>([]);

  final picker = ImagePicker();
  bool isSaving = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    imagesNotifier.dispose();
    filesNotifier.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null && mounted) {
      final file = File(pickedFile.path);

      // Validate size < 100 KB before adding to list
      if (!storageService.validateFileSize(file, context)) {
        return;
      }

      final currentImages = List<File>.from(imagesNotifier.value);
      currentImages.add(file);
      imagesNotifier.value = currentImages;
    }
  }

  void removeImage(int index) {
    final currentImages = List<File>.from(imagesNotifier.value);
    currentImages.removeAt(index);
    imagesNotifier.value = currentImages;
  }

  Future<void> pickFiles() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      final currentFiles = List<PlatformFile>.from(filesNotifier.value);
      currentFiles.addAll(result.files);
      filesNotifier.value = currentFiles;
    }
  }

  void removeFile(int index) {
    final currentFiles = List<PlatformFile>.from(filesNotifier.value);
    currentFiles.removeAt(index);
    filesNotifier.value = currentFiles;
  }

  Future<void> onAddProject() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title is required")),
      );
      return;
    }

    final myID = ref.read(authProvider).jobSeeker?.jobSeekerID ?? '';
    if (myID.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not found. Please log in again.")),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final projectId = FirebaseService.generateID();
      final uploadedUrls = <String>[];

      // Upload selected images to Firebase Storage
      for (final imgFile in imagesNotifier.value) {
        final url = await storageService.uploadPortfolioImage(
          userId: myID,
          projectId: projectId,
          file: imgFile,
          context: context,
        );
        if (url != null) {
          uploadedUrls.add(url);
        }
      }

      final fileNames = filesNotifier.value.map((f) => f.name).toList();

      final project = ProjectModel(
        projectID: projectId,
        jobSeekerID: myID,
        projectTitle: titleController.text.trim(),
        projectDescription: descriptionController.text.trim(),
        techStack: fileNames,
        mediaFiles: uploadedUrls,
      );

      await firebaseService.saveProject(project);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Project Added Successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElevateColor.white,
      body: SafeArea(
        child: Column(
          children: [
            const ElevateHeader(
              title: "New Portfolio",
              subTitle: "Add your latest work to shine",
              titleSize: 30,
              subtitleSize: 13,
              showBackButton: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "Project Title",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: titleController,
                      hintText: "E.g. E-Commerce Flutter App",
                      cursorColor: Colors.black,
                      underlineColor: Colors.grey,
                      textColor: Colors.black,
                    ),
                    const SizedBox(height: 20),
                    const CustomText(
                      text: "Project Description",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: descriptionController,
                      hintText: "Describe your role, architecture, & achievements",
                      cursorColor: Colors.black,
                      underlineColor: Colors.grey,
                      textColor: Colors.black,
                    ),
                    const SizedBox(height: 25),

                    // Screenshots / Images Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          text: "Screenshots (< 100KB each)",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_a_photo_outlined),
                          onPressed: pickImage,
                        ),
                      ],
                    ),
                    ValueListenableBuilder<List<File>>(
                      valueListenable: imagesNotifier,
                      builder: (context, images, _) {
                        if (images.isEmpty) {
                          return const Text(
                            "No screenshots selected",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          );
                        }
                        return SizedBox(
                          height: 90,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      images[index],
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: GestureDetector(
                                      onTap: () => removeImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 25),

                    // Tech Stack Files / Attachments Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          text: "Attach Tech Files / Specs",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        IconButton(
                          icon: const Icon(Icons.attach_file),
                          onPressed: pickFiles,
                        ),
                      ],
                    ),
                    ValueListenableBuilder<List<PlatformFile>>(
                      valueListenable: filesNotifier,
                      builder: (context, files, _) {
                        if (files.isEmpty) {
                          return const Text(
                            "No files selected",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          );
                        }
                        return Wrap(
                          spacing: 8,
                          children: List.generate(files.length, (index) {
                            return Chip(
                              label: Text(
                                files[index].name,
                                style: const TextStyle(fontSize: 12),
                              ),
                              onDeleted: () => removeFile(index),
                            );
                          }),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    isSaving
                        ? const Center(
                            child: CircularProgressIndicator(color: Colors.black),
                          )
                        : TextButtonGradient(
                            text: "SAVE PROJECT",
                            onTap: onAddProject,
                          ),
                    const SizedBox(height: 15),
                    TexxtButton(
                      text: "Cancel",
                      width: double.infinity,
                      height: 48,
                      textSize: 14,
                      textWeight: FontWeight.w400,
                      textColor: Colors.black,
                      backgroundColor: Colors.transparent,
                      borderRadius: 50,
                      borderColor: Colors.black,
                      onTap: () => Navigator.pop(context),
                    ),
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
