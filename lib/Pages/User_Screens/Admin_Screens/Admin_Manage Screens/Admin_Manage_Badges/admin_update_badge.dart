import 'package:elevate_app/Custom_Widgets/Tiles/badge_new_card.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Message_Box/messageBox.dart';
import 'package:elevate_app/Data_Model_Classes/Firebase_Online_Models/badge_model.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminUpdateBadge extends StatefulWidget {
  final BadgeModel badge;

  const AdminUpdateBadge({super.key, required this.badge});

  @override
  State<AdminUpdateBadge> createState() => _AdminUpdateBadgeState();
}

class _AdminUpdateBadgeState extends State<AdminUpdateBadge> {
  final FirebaseService firebaseService = FirebaseService();

  String? newBadgeImagePath;
  bool isUpdating = false;

  // Picks a badge image from the bundled assets (same as the create screen),
  // instead of uploading a picked file to Firebase Storage.
  Future<void> pickNewBadgeImage() async {
    final images = ["bronze.png", "silver.png", "gold.png"];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: images.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (_, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    newBadgeImagePath = images[index];
                  });

                  Navigator.pop(context);
                },
                child: Image.asset(
                  "lib/Resources/Images/Badges/${images[index]}",
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> updateBadge() async {
    if (newBadgeImagePath == null || newBadgeImagePath!.isEmpty) {
      showDialog(
        context: context,
        builder: (_) =>
            const Messagebox(message: "Please select a badge image."),
      );
      return;
    }

    setState(() => isUpdating = true);

    try {
      await firebaseService.updateBadge(widget.badge.badgeID, {
        "badgeImage": newBadgeImagePath,
      });

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      setState(() => isUpdating = false);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => const Messagebox(message: "Failed to update badge."),
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
              subTitle: "Badges",
              titleSize: 40,
              subtitleSize: 25,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    BadgeNewCard(
                      imagePath: newBadgeImagePath ?? widget.badge.badgeImage,
                      buttonText: isUpdating ? "UPDATING..." : "UPDATE BADGE",
                      onPickImage: pickNewBadgeImage,
                      onButtonTap: isUpdating ? () {} : updateBadge,
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
