import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Message_Box/messageBox.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/project_model.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Database/Online_Database/firebase_storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const int maxFileSizeBytes = 1024 * 1024; // 1 MB
const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];

class NewPortfolioScreen extends ConsumerStatefulWidget {
  const NewPortfolioScreen({super.key});

  @override
  ConsumerState<NewPortfolioScreen> createState() => _NewPortfolioScreenState();
}

class _NewPortfolioScreenState extends ConsumerState<NewPortfolioScreen> {
  final firebaseService = FirebaseService();
  final storageService = FirebaseStorageService();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  List<PlatformFile> images = [];
  List<PlatformFile> techFiles = [];
  bool isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (_) => Messagebox(message: message),
    );
  }

  // One function for both buttons. Images are restricted to JPEG/PNG.
  // Every file (image or tech file) must be under 1MB.
  Future<void> pickFiles(
    List<PlatformFile> target, {
    bool isImage = false,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );
    if (result == null) return;

    final tooBig = <String>[];
    final badFormat = <String>[];
    final accepted = <PlatformFile>[];

    for (final f in result.files) {
      final ext = f.name.contains('.')
          ? f.name.split('.').last.toLowerCase()
          : '';

      if (isImage && !allowedImageExtensions.contains(ext)) {
        badFormat.add(f.name);
        continue;
      }
      if (f.size > maxFileSizeBytes) {
        tooBig.add(f.name);
        continue;
      }
      accepted.add(f);
    }

    if (badFormat.isNotEmpty) {
      _showMessage(
        "Only JPEG and PNG images are allowed: ${badFormat.join(', ')}",
      );
    } else if (tooBig.isNotEmpty) {
      _showMessage(
        "These files are over 1MB and were skipped: ${tooBig.join(', ')}",
      );
    }

    setState(() => target.addAll(accepted));
  }

  Future<void> saveProject() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty) {
      _showMessage("Please enter project title");
      return;
    }

    final userId = ref.read(authProvider).jobSeeker?.jobSeekerID ?? '';
    if (userId.isEmpty) {
      _showMessage("User session invalid");
      return;
    }

    setState(() => isLoading = true);

    try {
      final projectId = FirebaseService.generateID();
      final imageUrls = <String>[];

      for (final img in images) {
        if (img.bytes == null) continue;
        final url = await storageService.uploadPortfolioImage(
          userId: userId,
          projectId: projectId,
          fileName: img.name,
          bytes: img.bytes!,
          context: context,
        );
        if (url != null) imageUrls.add(url);
      }

      final techNames = <String>[];
      final techUrls = <String>[];

      for (final f in techFiles) {
        if (f.bytes == null) continue;
        final url = await storageService.uploadTechFile(
          userId: userId,
          projectId: projectId,
          fileName: f.name,
          bytes: f.bytes!,
          context: context,
        );
        if (url != null) {
          techNames.add(f.name);
          techUrls.add(url);
        }
      }

      final project = ProjectModel(
        projectID: projectId,
        jobSeekerID: userId,
        projectTitle: title,
        projectDescription: description,
        techStack: techNames,
        techFileUrls: techUrls,
        mediaFiles: imageUrls,
      );

      await firebaseService.saveProject(project);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Project added successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to save project: $e")));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
    hintText: hint,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.black, width: 1.5),
    ),
  );

  Widget _uploadButton(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ElevateHeader(
              title: "New Portfolio",
              subTitle: "Add your latest work",
              titleSize: 26,
              subtitleSize: 13,
              showBackButton: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
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
                    TextField(
                      controller: titleController,
                      cursorColor: Colors.black,
                      decoration: _fieldDecoration("E.g. E-Commerce App"),
                    ),

                    const SizedBox(height: 20),

                    const CustomText(
                      text: "Project Description",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      cursorColor: Colors.black,
                      decoration: _fieldDecoration(
                        "Describe your project role and tech details...",
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          text: "Upload Images (JPEG/PNG, < 1MB)",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        _uploadButton(
                          "Select Image",
                          Icons.file_upload_outlined,
                          () => pickFiles(images, isImage: true),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (images.isEmpty)
                      const Text(
                        "No image files selected yet.",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      )
                    else
                      SizedBox(
                        height: 90,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) => Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  images[index].bytes!,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => images.removeAt(index)),
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
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
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          text: "Attach Tech Files / Specs (< 1MB)",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        _uploadButton(
                          "Select File",
                          Icons.attach_file,
                          () => pickFiles(techFiles),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (techFiles.isEmpty)
                      const Text(
                        "No tech files attached.",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(techFiles.length, (index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.insert_drive_file,
                                  size: 14,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  techFiles[index].name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => techFiles.removeAt(index)),
                                  child: const Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),

                    const SizedBox(height: 35),

                    isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : TextButtonGradient(
                            text: "SAVE PROJECT",
                            width: double.infinity,
                            height: 50,
                            textSize: 15,
                            textWeight: FontWeight.bold,
                            borderRadius: 30,
                            onTap: saveProject,
                          ),
                    const SizedBox(height: 12),
                    TexxtButton(
                      text: "Cancel",
                      width: double.infinity,
                      height: 50,
                      textSize: 15,
                      textWeight: FontWeight.bold,
                      textColor: Colors.black,
                      backgroundColor: Colors.transparent,
                      borderRadius: 30,
                      borderColor: Colors.black,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 20),
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
