import 'dart:io';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Message_Box/messageBox.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/badge_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Database/Online_Database/firebase_storage_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:elevate_app/constants/badge_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AdminUpdateBadge extends StatefulWidget {
  final BadgeModel badge;

  const AdminUpdateBadge({super.key, required this.badge});

  @override
  State<AdminUpdateBadge> createState() => _AdminUpdateBadgeState();
}

class _AdminUpdateBadgeState extends State<AdminUpdateBadge> {
  final FirebaseService firebaseService = FirebaseService();
  final FirebaseStorageService storageService = FirebaseStorageService();
  final ImagePicker picker = ImagePicker();

  File? pickedImageFile;
  String? currentImageUrl;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    currentImageUrl = widget.badge.badgeImage.isNotEmpty
        ? (widget.badge.badgeImage.startsWith('http')
            ? widget.badge.badgeImage
            : BadgeConstants.getBadgeUrl(widget.badge.badgeName))
        : BadgeConstants.getBadgeUrl(widget.badge.badgeName);
  }

  Future<void> pickNewBadgeImage() async {
    try {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final file = File(picked.path);
        if (!storageService.validateFileSize(file, context)) {
          return;
        }
        setState(() {
          pickedImageFile = file;
        });
      }
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => Messagebox(message: "Failed to pick image: $e"),
      );
    }
  }

  Future<void> updateBadge() async {
    if (pickedImageFile == null) {
      showDialog(
        context: context,
        builder: (_) => const Messagebox(
          message: "Please select a new image file to update badge.",
        ),
      );
      return;
    }

    setState(() => isUpdating = true);

    try {
      final uploadedUrl = await storageService.uploadBadgeImage(
        badgeId: widget.badge.badgeID,
        file: pickedImageFile!,
        context: context,
      );

      if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
        await firebaseService.updateBadge(widget.badge.badgeID, {
          "badgeImage": uploadedUrl,
        });

        if (!mounted) return;
        Navigator.pop(context, true);
      } else {
        setState(() => isUpdating = false);
      }
    } catch (_) {
      setState(() => isUpdating = false);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => const Messagebox(message: "Failed to update badge image."),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF3F3F3),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            const ElevateHeader(
              title: "Elevate",
              subTitle: "Update Badge Image",
              titleSize: 32,
              subtitleSize: 20,
              showBackButton: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          CustomText(
                            text: "${widget.badge.badgeName} Badge",
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            text:
                                "Required Score: ${widget.badge.minScore.toInt()} - ${widget.badge.maxScore.toInt()}",
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 25),
                          GestureDetector(
                            onTap: pickNewBadgeImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white12,
                              backgroundImage: pickedImageFile != null
                                  ? FileImage(pickedImageFile!)
                                  : NetworkImage(currentImageUrl!) as ImageProvider,
                              child: pickedImageFile == null
                                  ? const Align(
                                      alignment: Alignment.bottomRight,
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const CustomText(
                            text: "Tap circle to pick image under 1MB",
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isUpdating ? null : updateBadge,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: CustomText(
                                text: isUpdating ? "UPLOADING..." : "UPDATE IMAGE",
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TexxtButton(
                      text: "Cancel",
                      height: 50,
                      textSize: 14,
                      textColor: ElevateColor.gray,
                      textWeight: FontWeight.w400,
                      borderRadius: 50,
                      backgroundColor: Colors.transparent,
                      borderColor: ElevateColor.gray,
                      borderWidth: 1,
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
