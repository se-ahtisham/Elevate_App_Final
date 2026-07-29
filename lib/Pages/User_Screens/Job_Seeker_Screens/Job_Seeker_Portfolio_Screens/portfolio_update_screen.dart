import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Message_Box/messageBox.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/project_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Database/Online_Database/firebase_storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elevate_app/Utils/file_downloader.dart';

const int maxFileSizeBytes = 1024 * 1024; // 1 MB
const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];

/// A tech file that's already uploaded — has a name and a download URL.
class _ExistingTechFile {
  final String name;
  final String url;
  _ExistingTechFile(this.name, this.url);
}

class PortfolioUpdateScreen extends ConsumerStatefulWidget {
  final ProjectModel? project;
  const PortfolioUpdateScreen({super.key, this.project});

  @override
  ConsumerState<PortfolioUpdateScreen> createState() =>
      _PortfolioUpdateScreenState();
}

class _PortfolioUpdateScreenState extends ConsumerState<PortfolioUpdateScreen> {
  final firebaseService = FirebaseService();
  final storageService = FirebaseStorageService();

  late final TextEditingController descriptionController;

  List<String> existingImageUrls = [];
  List<PlatformFile> newImages = [];
  List<String> removedImageUrls = [];
  List<String> removedTechUrls = [];

  List<_ExistingTechFile> existingTechFiles = [];
  List<PlatformFile> newTechFiles = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController(
      text: widget.project?.projectDescription ?? '',
    );
    existingImageUrls = List<String>.from(widget.project?.mediaFiles ?? []);

    final names = widget.project?.techStack ?? [];
    final urls = widget.project?.techFileUrls ?? [];
    existingTechFiles = List.generate(
      names.length,
      (i) => _ExistingTechFile(names[i], i < urls.length ? urls[i] : ''),
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (_) => Messagebox(message: message),
    );
  }

  // Same picker for both images and tech files. Images are restricted to JPEG/PNG.
  // Every file must be under 1MB.
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

  Future<void> _downloadFile(String url, String fileName) async {
    try {
      await saveOrDownloadFile(url, fileName);
    } catch (_) {
      _showMessage("Couldn't open this file.");
    }
  }

  Future<void> updateProject() async {
    final project = widget.project;
    if (project == null) return;

    setState(() => isLoading = true);

    try {
      final updatedMediaUrls = <String>[...existingImageUrls];

      for (final img in newImages) {
        if (img.bytes == null) continue;
        if (!mounted) return;
        final url = await storageService.uploadPortfolioImage(
          userId: project.jobSeekerID,
          projectId: project.projectID,
          fileName: img.name,
          bytes: img.bytes!,
          context: context,
        );
        if (url != null) updatedMediaUrls.add(url);
      }

      final techNames = <String>[for (final t in existingTechFiles) t.name];
      final techUrls = <String>[for (final t in existingTechFiles) t.url];

      for (final f in newTechFiles) {
        if (f.bytes == null) continue;
        if (!mounted) return;
        final url = await storageService.uploadTechFile(
          userId: project.jobSeekerID,
          projectId: project.projectID,
          fileName: f.name,
          bytes: f.bytes!,
          context: context,
        );
        if (url != null) {
          techNames.add(f.name);
          techUrls.add(url);
        }
      }

      for (final url in removedImageUrls) {
        await storageService.deleteFileFromStorage(url);
      }
      for (final url in removedTechUrls) {
        await storageService.deleteFileFromStorage(url);
      }
      await firebaseService.updateProject(project.projectID, {
        'projectDescription': descriptionController.text.trim(),
        'techStack': techNames,
        'techFileUrls': techUrls,
        'mediaFiles': updatedMediaUrls,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Portfolio updated successfully!")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Update failed: $e")));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> deleteProject() async {
    final project = widget.project;
    if (project == null) return;

    setState(() => isLoading = true);

    try {
      for (final url in project.mediaFiles) {
        await storageService.deleteFileFromStorage(url);
      }
      for (final url in project.techFileUrls) {
        await storageService.deleteFileFromStorage(url);
      }

      await firebaseService.deleteProject(
        project.projectID,
        project.jobSeekerID,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Project deleted successfully.")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Delete failed: $e")));
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

  Widget _techChip({
    required String name,
    VoidCallback? onDownload,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.insert_drive_file, size: 14, color: Colors.black),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              name,
              style: const TextStyle(fontSize: 12, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onDownload != null) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onDownload,
              child: const Icon(
                Icons.download_rounded,
                size: 14,
                color: Colors.black,
              ),
            ),
          ],
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ElevateHeader(
              title: "Edit Project",
              subTitle: "Update your portfolio details",
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
                    CustomText(
                      text: project?.projectTitle ?? "Project",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
                        "Enter updated description...",
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          text: "Attached Images (JPEG/PNG, < 1MB)",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        _uploadButton(
                          "Add Image",
                          Icons.file_upload_outlined,
                          () => pickFiles(newImages, isImage: true),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (existingImageUrls.isEmpty && newImages.isEmpty)
                      const Text(
                        "No images uploaded yet.",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      )
                    else
                      SizedBox(
                        height: 95,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (int i = 0; i < existingImageUrls.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        existingImageUrls[i],
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 90,
                                          height: 90,
                                          color: Colors.grey.shade300,
                                          child: const Icon(Icons.broken_image),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: GestureDetector(
                                        onTap: () => setState(() {
                                          removedImageUrls.add(
                                            existingImageUrls[i],
                                          );
                                          existingImageUrls.removeAt(i);
                                        }),
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
                            for (int j = 0; j < newImages.length; j++)
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(
                                        newImages[j].bytes!,
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: GestureDetector(
                                        onTap: () => setState(
                                          () => newImages.removeAt(j),
                                        ),
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
                          ],
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
                          () => pickFiles(newTechFiles),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (existingTechFiles.isEmpty && newTechFiles.isEmpty)
                      const Text(
                        "No tech files attached.",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (int i = 0; i < existingTechFiles.length; i++)
                            _techChip(
                              name: existingTechFiles[i].name,
                              onDownload: existingTechFiles[i].url.isEmpty
                                  ? null
                                  : () => _downloadFile(
                                        existingTechFiles[i].url,
                                        existingTechFiles[i].name,
                                      ),
                              onRemove: () => setState(() {
                                if (existingTechFiles[i].url.isNotEmpty) {
                                  removedTechUrls.add(existingTechFiles[i].url);
                                }
                                existingTechFiles.removeAt(i);
                              }),
                            ),
                          for (int j = 0; j < newTechFiles.length; j++)
                            _techChip(
                              name: newTechFiles[j].name,
                              onDownload:
                                  null, // uploads only when you tap Update Project
                              onRemove: () =>
                                  setState(() => newTechFiles.removeAt(j)),
                            ),
                        ],
                      ),

                    const SizedBox(height: 35),

                    isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : Column(
                            children: [
                              TextButtonGradient(
                                text: "UPDATE PROJECT",
                                width: double.infinity,
                                height: 50,
                                textSize: 15,
                                textWeight: FontWeight.bold,
                                borderRadius: 30,
                                onTap: updateProject,
                              ),
                              const SizedBox(height: 12),
                              TexxtButton(
                                text: "DELETE PROJECT",
                                width: double.infinity,
                                height: 50,
                                textSize: 15,
                                textWeight: FontWeight.bold,
                                textColor: const Color.fromARGB(
                                  255,
                                  70,
                                  70,
                                  70,
                                ),
                                backgroundColor: Colors.transparent,
                                borderRadius: 30,
                                borderColor: const Color.fromARGB(
                                  255,
                                  65,
                                  65,
                                  65,
                                ),
                                onTap: deleteProject,
                              ),
                            ],
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
