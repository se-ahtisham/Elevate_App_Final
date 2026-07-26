import 'package:elevate_app/Custom_Widgets/Buttons/circle_icon_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/project_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminDeletePortfolio extends StatefulWidget {
  final ProjectModel project;

  const AdminDeletePortfolio({super.key, required this.project});

  @override
  State<AdminDeletePortfolio> createState() => AdminDeletePortfolioState();
}

class AdminDeletePortfolioState extends State<AdminDeletePortfolio> {
  final FirebaseService service = FirebaseService();
  bool isDeleting = false;

  Future<void> deleteProject() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Project"),
        content: const Text("This cannot be undone. Delete this project?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => isDeleting = true);
    try {
      await service.deleteProject(
        widget.project.projectID,
        widget.project.jobSeekerID,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to delete project: $e")));
    } finally {
      if (mounted) setState(() => isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final images = project.mediaFiles;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  const ElevateHeader(),
                  Positioned(
                    top: 60,
                    right: 20,
                    child: GestureDetector(
                      onTap: isDeleting ? null : deleteProject,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: isDeleting
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Delete Project",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        const CustomText(
                          text: "My Creation",
                          fontSize: 16,
                          textAlign: TextAlign.left,
                          fontWeight: FontWeight.w700,
                          color: ElevateColor.lightgray,
                          lineHeight: 1.2,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 92,
                          child: images.isEmpty
                              ? const Center(child: Text("No images"))
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: images.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 14),
                                  itemBuilder: (context, i) {
                                    return PreviewCard(
                                      imageUrl: images[i],
                                      heroTag: "preview_$i",
                                    );
                                  },
                                ),
                        ),
                        const SizedBox(height: 20),
                        const CustomText(
                          text: "Description",
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: ElevateColor.lightgray,
                          lineHeight: 1.2,
                        ),
                        const SizedBox(height: 10),
                        CustomText(
                          text: project.projectDescription.isNotEmpty
                              ? project.projectDescription
                              : "No description provided.",
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: ElevateColor.whitegray,
                          lineHeight: 1.45,
                        ),
                        const SizedBox(height: 18),
                        const CustomText(
                          text: "Files",
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: ElevateColor.lightgray,
                          lineHeight: 1.2,
                        ),
                        const SizedBox(height: 12),
                        if (project.techStack.isEmpty)
                          const CustomText(
                            text: "No files uploaded.",
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: ElevateColor.whitegray,
                            lineHeight: 1.2,
                          )
                        else
                          ...List.generate(project.techStack.length, (i) {
                            final fileName = project.techStack[i];
                            // techFileUrls is in the same order as techStack
                            final fileUrl = i < project.techFileUrls.length
                                ? project.techFileUrls[i]
                                : '';
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: FilePill(
                                fileName: fileName,
                                onDownload: () async {
                                  if (fileUrl.isNotEmpty) {
                                    final uri = Uri.parse(fileUrl);
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri);
                                    }
                                  }
                                },
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, top: 150),
            child: Container(
              width: double.infinity,
              height: 140,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              decoration: BoxDecoration(
                color: ElevateColor.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    color: Colors.black.withValues(alpha: 0.12),
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: project.projectTitle.isNotEmpty
                        ? project.projectTitle
                        : "Untitled Project",
                    textAlign: TextAlign.center,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: ElevateColor.lightgray,
                    lineHeight: 1.15,
                  ),
                  if (project.projectURL.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    CustomText(
                      text: project.projectURL,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: ElevateColor.whitegray,
                      lineHeight: 1.2,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PreviewCard extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const PreviewCard({super.key, required this.imageUrl, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                FullScreenImage(imageUrl: imageUrl, heroTag: heroTag),
          ),
        );
      },
      child: Container(
        width: 156,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ElevateColor.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 14,
              color: Colors.black.withValues(alpha: 0.08),
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Hero(
          tag: heroTag,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFFF2F2F2),
              alignment: Alignment.center,
              child: const Icon(
                Icons.image_outlined,
                size: 28,
                color: Color(0xFF9B9B9B),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const FullScreenImage({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElevateColor.black,
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: heroTag,
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,
                child: Image.network(imageUrl),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: CircleIconButton(
              iconData: Icons.arrow_back,
              circleSize: 40,
              iconSize: 20,
              circleColor: ElevateColor.white.withValues(alpha: 0.20),
              iconColor: ElevateColor.white,
              rippleColor: ElevateColor.white.withValues(alpha: 0.30),
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class FilePill extends StatelessWidget {
  final String fileName;
  final VoidCallback onDownload;

  const FilePill({super.key, required this.fileName, required this.onDownload});

  @override
  Widget build(BuildContext context) {
    const border = Color(0xFFE0E0E0);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: ElevateColor.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Expanded(
            child: CustomText(
              text: fileName,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: ElevateColor.lightgray,
              lineHeight: 1.2,
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onDownload,
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Icon(
                Icons.download_rounded,
                size: 20,
                color: ElevateColor.lightgray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
