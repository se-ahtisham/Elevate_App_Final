import 'dart:io';
import 'dart:typed_data';
import 'package:elevate_app/Custom_Widgets/Message_Box/messageBox.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseStorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  static const int maxFileSizeBytes = 1 * 1024 * 1024; // 1 MB
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];

  String _extensionOf(String fileName) {
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  void _showMessage(BuildContext context, String message) {
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (_) => Messagebox(message: message),
    );
  }

  bool validateFileSize(File file, BuildContext context) {
    if (file.lengthSync() >= maxFileSizeBytes) {
      _showMessage(context, "Please select file that is less than 1MB");
      return false;
    }
    return true;
  }

  bool validateBytesSize(Uint8List bytes, BuildContext context) {
    if (bytes.lengthInBytes >= maxFileSizeBytes) {
      _showMessage(context, "Please select file that is less than 1MB");
      return false;
    }
    return true;
  }

  /// Only jpg/jpeg/png are accepted as portfolio images.
  bool validateImageFormat(String fileName, BuildContext context) {
    if (!allowedImageExtensions.contains(_extensionOf(fileName))) {
      _showMessage(context, "Only JPEG and PNG images are allowed");
      return false;
    }
    return true;
  }

  String _imageContentType(String fileName) {
    switch (_extensionOf(fileName)) {
      case 'png':
        return 'image/png';
      default:
        return 'image/jpeg';
    }
  }

  Future<String?> uploadProfileImage({
    required String userId,
    required File file,
    required BuildContext context,
  }) async {
    if (!validateFileSize(file, context)) return null;
    try {
      final ref = storage.ref().child('profile_pictures').child('$userId.jpg');
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      if (context.mounted) {
        _showMessage(
          context,
          "Failed to upload profile picture: ${e.toString()}",
        );
      }
      return null;
    }
  }

  /// Uploads a portfolio image. Only JPEG/PNG under 1MB are accepted.
  /// Uses raw bytes so it works on web, mobile, and desktop.
  Future<String?> uploadPortfolioImage({
    required String userId,
    required String projectId,
    required String fileName,
    required Uint8List bytes,
    required BuildContext context,
  }) async {
    if (!validateImageFormat(fileName, context)) return null;
    if (!validateBytesSize(bytes, context)) return null;

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ext = _extensionOf(fileName);
      final ref = storage
          .ref()
          .child('portfolio_images')
          .child(userId)
          .child('${projectId}_$timestamp.$ext');

      final uploadTask = await ref.putData(
        bytes,
        SettableMetadata(contentType: _imageContentType(fileName)),
      );
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      if (context.mounted) {
        _showMessage(
          context,
          "Failed to upload portfolio image: ${e.toString()}",
        );
      }
      return null;
    }
  }

  /// Uploads a tech spec/document file (any format) and returns its download URL,
  /// so it can be stored alongside the file name and downloaded later.
  Future<String?> uploadTechFile({
    required String userId,
    required String projectId,
    required String fileName,
    required Uint8List bytes,
    required BuildContext context,
  }) async {
    if (!validateBytesSize(bytes, context)) return null;

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ref = storage
          .ref()
          .child('tech_files')
          .child(userId)
          .child('${projectId}_${timestamp}_$fileName');

      final uploadTask = await ref.putData(bytes);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, "Failed to upload tech file: ${e.toString()}");
      }
      return null;
    }
  }

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
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, "Failed to upload post image: ${e.toString()}");
      }
      return null;
    }
  }

  Future<String?> uploadSkillImage({
    required String skillId,
    required File file,
    required BuildContext context,
  }) async {
    if (!validateFileSize(file, context)) return null;
    try {
      final ext = file.path.split('.').last.toLowerCase();
      final ref = storage.ref().child('skill_images').child('$skillId.$ext');
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, "Failed to upload skill image: ${e.toString()}");
      }
      return null;
    }
  }

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
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, "Failed to upload resume file: ${e.toString()}");
      }
      return null;
    }
  }

  Future<String?> uploadBadgeImage({
    required String badgeId,
    required File file,
    required BuildContext context,
  }) async {
    if (!validateFileSize(file, context)) return null;
    try {
      final ext = file.path.split('.').last.toLowerCase();
      final ref = storage.ref().child('badge_images').child('$badgeId.$ext');
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, "Failed to upload badge image: ${e.toString()}");
      }
      return null;
    }
  }

  Future<String?> uploadCompanyImage({
    required String companyId,
    required File file,
    required BuildContext context,
  }) async {
    if (!validateFileSize(file, context)) return null;
    try {
      final ext = file.path.split('.').last.toLowerCase();
      final ref = storage.ref().child('company_logos').child('$companyId.$ext');
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, "Failed to upload company logo: ${e.toString()}");
      }
      return null;
    }
  }

  Future<bool> deleteFileFromStorage(String fileUrl) async {
    try {
      await storage.refFromURL(fileUrl).delete();
      return true;
    } catch (_) {
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // DEMO ONLY — isolated under demo_files/ prefix, no real user data touched
  // ─────────────────────────────────────────────────────────────────────────

  /// Uploads raw bytes to `demo_files/<fileName>` in Storage.
  /// This path is completely separate from all real user uploads.
  /// Returns the public download URL, or null on failure.
  Future<String?> uploadDemoFile({
    required String fileName,
    required Uint8List bytes,
    String contentType = 'text/plain',
  }) async {
    try {
      final ref = storage.ref().child('demo_files').child(fileName);
      final uploadTask = await ref.putData(
        bytes,
        SettableMetadata(
          contentType: contentType,
          customMetadata: {'purpose': 'demo', 'createdBy': 'seed_script'},
        ),
      );
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      // ignore: avoid_print
      print('[DEMO] Failed to upload demo file: $e');
      return null;
    }
  }

  /// Deletes the demo file at `demo_files/<fileName>` from Storage.
  Future<bool> deleteDemoFile(String fileName) async {
    try {
      await storage.ref().child('demo_files').child(fileName).delete();
      return true;
    } catch (_) {
      return false;
    }
  }
}
