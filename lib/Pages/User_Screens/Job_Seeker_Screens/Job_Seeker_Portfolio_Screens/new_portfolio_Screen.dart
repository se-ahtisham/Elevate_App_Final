import 'dart:io';
import 'package:elevate_app/Custom_Widgets/Buttons/contain_icon_text_button.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/project_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class NewPortfolioScreen extends ConsumerStatefulWidget {
  const NewPortfolioScreen({super.key});

  @override
  ConsumerState<NewPortfolioScreen> createState() => _NewPortfolioScreenState();
}

class _NewPortfolioScreenState extends ConsumerState<NewPortfolioScreen> {
  final firebaseService = FirebaseService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final ValueNotifier<List<File>> imagesNotifier =
      ValueNotifier<List<File>>([]);
  final ValueNotifier<List<PlatformFile>> filesNotifier =
      ValueNotifier<List<PlatformFile>>([]);

  final ImagePicker picker = ImagePicker();
  bool isSaving = false;

  Future<void> pickImage() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final currentImages = List<File>.from(imagesNotifier.value);
      currentImages.add(File(pickedFile.path));
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
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title is required")),
      );
      return;
    }

    final myID =
        ref.read(authProvider).jobSeeker?.jobSeekerID ?? '';
    if (myID.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not found. Please log in again.")),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final fileNames = filesNotifier.value.map((f) => f.name).toList();

      final project = ProjectModel(
        projectID: FirebaseService.generateID(),
        jobSeekerID: myID,
        projectTitle: titleController.text.trim(),
        projectDescription: descriptionController.text.trim(),
        techStack: fileNames,
        mediaFiles: [], // In production, upload images and store URLs here
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
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    imagesNotifier.dispose();
    filesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          ElevateHeader(
            title: "Portfolio Project",
            subTitle: "Add new project",
            titleSize: 25,
            subtitleSize: 15,
            showBackButton: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    const CustomText(
                      text: "UPLOAD IMAGES",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ElevateColor.lightgray,
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      height: 120,
                      child: ValueListenableBuilder<List<File>>(
                        valueListenable: imagesNotifier,
                        builder: (context, images, child) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length + 1,
                            itemBuilder: (context, index) {
                              if (index == images.length) {
                                return GestureDetector(
                                  onTap: pickImage,
                                  child: Container(
                                    width: 140,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAEAEA),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return Stack(
                                children: [
                                  Container(
                                    width: 140,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.file(
                                      images[index],
                                      fit: BoxFit.cover,
                                      width: 140,
                                      height: 120,
                                    ),
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: 18,
                                    child: GestureDetector(
                                      onTap: () => removeImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    CustomTextField(
                      controller: titleController,
                      hintText: "Title",
                      cursorColor: Colors.black,
                      underlineColor: Colors.grey,
                    ),
                    const SizedBox(height: 40),

                    CustomTextField(
                      controller: descriptionController,
                      hintText: "Description",
                      cursorColor: Colors.black,
                      underlineColor: Colors.grey,
                    ),
                    const SizedBox(height: 25),

                    const CustomText(
                      text: "Files",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ElevateColor.lightgray,
                    ),
                    const SizedBox(height: 12),

                    ContainIconTextButton(text: "Add Files", onTap: pickFiles),
                    const SizedBox(height: 12),

                    ValueListenableBuilder<List<PlatformFile>>(
                      valueListenable: filesNotifier,
                      builder: (context, files, child) {
                        if (files.isEmpty) return const SizedBox.shrink();
                        return Column(
                          children: files.asMap().entries.map((entry) {
                            int index = entry.key;
                            PlatformFile file = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.insert_drive_file,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: CustomText(
                                      text: file.name,
                                      fontSize: 14,
                                      color: ElevateColor.black,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    onPressed: () => removeFile(index),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    TextButtonGradient(
                      text: isSaving ? "SAVING..." : "ADD PROJECT",
                      height: 50,
                      textSize: 14,
                      textColor: ElevateColor.white,
                      textWeight: FontWeight.w400,
                      borderRadius: 50,
                      borderColor: ElevateColor.gray,
                      borderWidth: 1,
                      onTap: isSaving ? null : onAddProject,
                    ),
                    const SizedBox(height: 35),

                    TexxtButton(
                      text: "Back",
                      height: 50,
                      textSize: 14,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      borderColor: Colors.black,
                      borderWidth: 1,
                      textWeight: FontWeight.w400,
                      borderRadius: 50,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),

                    const SizedBox(height: 40),
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
