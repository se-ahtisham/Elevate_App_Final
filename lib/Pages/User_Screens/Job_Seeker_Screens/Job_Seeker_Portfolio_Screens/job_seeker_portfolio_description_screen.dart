import 'package:elevate_app/Custom_Widgets/Buttons/circle_icon_button.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Message_Box/messageBox.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/project_model.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Portfolio_Screens/portfolio_update_screen.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:elevate_app/Utils/file_downloader.dart';

class JobSeekerPortfolioDescriptionScreen extends StatelessWidget {
  final ProjectModel? project;

  const JobSeekerPortfolioDescriptionScreen({super.key, this.project});

  Future<void> downloadOrWarn(
    BuildContext context,
    String url,
    String fileName,
  ) async {
    if (url.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const Messagebox(
          message:
              "This file can't be downloaded. Please re-upload it under Edit Project.",
        ),
      );
      return;
    }
    try {
      await saveOrDownloadFile(url, fileName);
    } catch (_) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => const Messagebox(message: "Couldn't open this file."),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = project;
    final previewImages = p?.mediaFiles ?? [];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      body: Column(
        children: [
          ElevateHeader(
            title: p?.projectTitle.isNotEmpty == true
                ? p!.projectTitle
                : "Project Details",
            subTitle: p?.techStack.isNotEmpty == true
                ? p!.techStack.join(', ')
                : "Developer",
            titleSize: 24,
            subtitleSize: 14,
            showBackButton: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "Project Media",
                      fontSize: 16,
                      textAlign: TextAlign.left,
                      fontWeight: FontWeight.w700,
                      color: ElevateColor.lightgray,
                      lineHeight: 1.2,
                    ),
                    const SizedBox(height: 12),

                    // Preview images
                    if (previewImages.isNotEmpty)
                      SizedBox(
                        height: 110,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: previewImages.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 14),
                          itemBuilder: (context, i) {
                            return _NetworkPreviewCard(
                              imageUrl: previewImages[i],
                              heroTag: "preview_$i",
                            );
                          },
                        ),
                      )
                    else
                      Container(
                        height: 70,
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "No images uploaded.",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),

                    const SizedBox(height: 24),
                    const CustomText(
                      text: "Description",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: ElevateColor.lightgray,
                      lineHeight: 1.2,
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      text: p?.projectDescription.isNotEmpty == true
                          ? p!.projectDescription
                          : "No description provided.",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      lineHeight: 1.45,
                    ),

                    const SizedBox(height: 24),

                    const CustomText(
                      text: "Attached Tech Files",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: ElevateColor.lightgray,
                      lineHeight: 1.2,
                    ),
                    const SizedBox(height: 12),

                    if (p == null || p.techStack.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          "No files attached.",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      )
                    else
                      ...List.generate(p.techStack.length, (i) {
                        final fileName = p.techStack[i];
                        final url = i < p.techFileUrls.length
                            ? p.techFileUrls[i]
                            : '';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _FilePill(
                            fileName: fileName,
                            onDownload: () =>
                                downloadOrWarn(context, url, fileName),
                          ),
                        );
                      }),

                    const SizedBox(height: 30),

                    TextButtonGradient(
                      text: "Update Project",
                      textSize: 15,
                      textColor: Colors.white,
                      textWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                      borderRadius: 50,
                      borderWidth: 1,
                      height: 50,
                      width: double.infinity,
                      onTap: () async {
                        final changed = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PortfolioUpdateScreen(project: p),
                          ),
                        );
                        if (changed == true && context.mounted) {
                          Navigator.pop(context);
                        }
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

// Network Preview Card

class _NetworkPreviewCard extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const _NetworkPreviewCard({required this.imageUrl, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                _FullScreenNetworkImage(imageUrl: imageUrl, heroTag: heroTag),
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

class _FullScreenNetworkImage extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const _FullScreenNetworkImage({
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

// File Pill

class _FilePill extends StatelessWidget {
  final String fileName;
  final VoidCallback onDownload;

  const _FilePill({required this.fileName, required this.onDownload});

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
          CustomText(
            text: fileName,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: ElevateColor.lightgray,
            lineHeight: 1.2,
          ),
          const Spacer(),
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
