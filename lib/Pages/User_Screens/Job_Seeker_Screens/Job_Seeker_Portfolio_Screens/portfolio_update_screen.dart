import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/project_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Portfolio_Screens/porfolio_screen.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class PortfolioUpdateScreen extends ConsumerStatefulWidget {
  final ProjectModel? project;

  const PortfolioUpdateScreen({super.key, this.project});

  @override
  ConsumerState<PortfolioUpdateScreen> createState() =>
      _PortfolioUpdateScreenState();
}

class _PortfolioUpdateScreenState
    extends ConsumerState<PortfolioUpdateScreen> {
  final firebaseService = FirebaseService();

  final ValueNotifier<List<File>> imagesNotifier =
      ValueNotifier<List<File>>([]);
  final ValueNotifier<List<PlatformFile>> filesNotifier =
      ValueNotifier<List<PlatformFile>>([]);

  late final TextEditingController descriptionController;
  final ImagePicker picker = ImagePicker();

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController(
      text: widget.project?.projectDescription ?? '',
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    imagesNotifier.dispose();
    filesNotifier.dispose();
    super.dispose();
  }

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

  Future<void> onUpdate() async {
    final project = widget.project;
    if (project == null) return;

    setState(() => isSaving = true);

    try {
      final fileNames = filesNotifier.value.map((f) => f.name).toList();

      await firebaseService.updateProject(
        project.projectID,
        {
          'projectDescription': descriptionController.text.trim(),
          'techStack': fileNames.isNotEmpty ? fileNames : project.techStack,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Project updated successfully!")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PorfolioScreen()),
      );
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
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: SafeArea(
        child: Column(
          children: [
            ElevateHeader(
              title: widget.project?.projectTitle ?? "Project",
              subTitle: "Update",
              titleSize: 22,
              subtitleSize: 14,
              showBackButton: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        text: "UPDATE IMAGES",
                        fontSize: 13,
                        textAlign: TextAlign.left,
                        fontWeight: FontWeight.w700,
                        color: ElevateColor.lightgray,
                        lineHeight: 1.2,
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        height: 110,
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
                                      width: 100,
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.add,
                                          size: 32,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                return Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.file(
                                        images[index],
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 110,
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

                      const SizedBox(height: 24),

                      TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          hintText: "Description",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border: const UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ElevateColor.lightgray,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      const CustomText(
                        text: "Files",
                        fontSize: 13,
                        textAlign: TextAlign.left,
                        fontWeight: FontWeight.w700,
                        color: ElevateColor.lightgray,
                        lineHeight: 1.2,
                      ),

                      const SizedBox(height: 14),

                      ValueListenableBuilder<List<PlatformFile>>(
                        valueListenable: filesNotifier,
                        builder: (context, files, child) {
                          return Column(
                            children: [
                              ...List.generate(
                                files.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 48,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                              255,
                                              236,
                                              236,
                                              236,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            files[index].name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                255,
                                                110,
                                                110,
                                                110,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      GestureDetector(
                                        onTap: () => removeFile(index),
                                        child: Container(
                                          width: 38,
                                          height: 38,
                                          decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                              255,
                                              220,
                                              220,
                                              220,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.remove,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              GestureDetector(
                                onTap: pickFiles,
                                child: Container(
                                  width: double.infinity,
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      236,
                                      236,
                                      236,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Add More Files",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                            255,
                                            110,
                                            110,
                                            110,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                      TextButtonGradient(
                        height: 40,
                        text: isSaving ? "SAVING..." : "UPDATE",
                        onTap: isSaving ? null : onUpdate,
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
