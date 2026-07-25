import 'dart:io';
import 'package:elevate_app/Custom_Widgets/Message_Box/messageBox.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseStorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Maximum allowed upload size (100 KB = 102,400 Bytes)
  static const int maxFileSizeBytes = 100 * 1024;

  /// Checks if the selected file size is less than 100 KB.
  /// Displays a Messagebox if the file exceeds the 100 KB limit.
  bool validateFileSize(File file, BuildContext context) {
    final fileLength = file.lengthSync();
    if (fileLength >= maxFileSizeBytes) {
      showDialog(
        context: context,
        builder: (context) => const Messagebox(
          message: "Please select file that is less than 100KB",
        ),
      );
      return false;
    }
    return true;
  }

  /// Uploads a profile picture to 'profile_pictures/{userId}'
  Future<String?> uploadProfileImage({
    required String userId,
    required File file,
    required BuildContext context,
  }) async {
    if (!validateFileSize(file, context)) return null;

    try {
      final ref = storage.ref().child('profile_pictures').child('$userId.jpg');
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => Messagebox(
            message: "Failed to upload profile picture: ${e.toString()}",
          ),
        );
      }
      return null;
    }
  }

  /// Uploads a portfolio project image to 'portfolio_images/{userId}/{projectId}'
  Future<String?> uploadPortfolioImage({
    required String userId,
    required String projectId,
    required File file,
    required BuildContext context,
  }) async {
    if (!validateFileSize(file, context)) return null;

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ref = storage
          .ref()
          .child('portfolio_images')
          .child(userId)
          .child('${projectId}_$timestamp.jpg');

      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => Messagebox(
            message: "Failed to upload portfolio image: ${e.toString()}",
          ),
        );
      }
      return null;
    }
  }

  /// Uploads a community post image to 'community_posts/{userId}'
  Future<String?> uploadPostMedia({
    required String userId,
    required File file,
    required BuildContext context,
  }) async {
    if (!validateFileSize(file, context)) return null;

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ref = storage
          .ref()
          .child('community_posts')
          .child(userId)
          .child('post_$timestamp.jpg');

      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => Messagebox(
            message: "Failed to upload post image: ${e.toString()}",
          ),
        );
      }
      return null;
    }
  }

  /// Uploads a resume document file to 'resumes/{userId}'
  Future<String?> uploadResumeFile({
    required String userId,
    required File file,
    required BuildContext context,
  }) async {
    if (!validateFileSize(file, context)) return null;

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = file.path.split('.').last;
      final ref = storage
          .ref()
          .child('resumes')
          .child(userId)
          .child('resume_$timestamp.$extension');

      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => Messagebox(
            message: "Failed to upload resume file: ${e.toString()}",
          ),
        );
      }
      return null;
    }
  }

  /// Deletes a file from Firebase Storage given its HTTPS URL.
  Future<bool> deleteFileFromStorage(String fileUrl) async {
    try {
      final ref = storage.refFromURL(fileUrl);
      await ref.delete();
      return true;
    } catch (_) {
      return false;
    }
  }
}
