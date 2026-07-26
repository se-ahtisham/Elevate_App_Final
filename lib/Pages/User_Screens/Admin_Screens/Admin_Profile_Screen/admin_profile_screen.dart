import 'dart:io';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text_background_box/custom_text_box.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Database/Online_Database/firebase_service.dart';
import 'package:elevate_app/Database/Online_Database/firebase_storage_service.dart';
import 'package:elevate_app/Pages/Login_Screens/login_screen.dart';
import 'package:elevate_app/Pages/User_Screens/Admin_Screens/Admin_Profile_Screen/admin_forget_screen.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AdminProfileScreen extends ConsumerStatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  ConsumerState<AdminProfileScreen> createState() => AdminProfileScreenState();
}

class AdminProfileScreenState extends ConsumerState<AdminProfileScreen> {
  final FirebaseService service = FirebaseService();
  final FirebaseStorageService storageService = FirebaseStorageService();

  final aboutController = TextEditingController();
  final locationController = TextEditingController();

  bool isSaving = false;
  bool isUploadingImage = false;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadAdmin());
  }

  Future<void> loadAdmin() async {
    final notifier = ref.read(authProvider.notifier);
    if (notifier.admin == null) {
      await notifier.loadCurrentUser();
    }
    final admin = notifier.admin;
    if (admin != null) {
      aboutController.text = admin.about;
      locationController.text = admin.location;
    }
    if (mounted) setState(() => loaded = true);
  }

  @override
  void dispose() {
    aboutController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    final admin = ref.read(authProvider.notifier).admin;
    if (admin == null) return;

    setState(() => isSaving = true);
    try {
      await service.updateAdmin(admin.adminID, {
        'about': aboutController.text.trim(),
        'location': locationController.text.trim(),
      });
      await ref.read(authProvider.notifier).loadCurrentUser();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profile updated.")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to update: $e")));
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  Future<void> pickAndUploadImage() async {
    final admin = ref.read(authProvider.notifier).admin;
    if (admin == null) return;

    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    if (!mounted) return;

    setState(() => isUploadingImage = true);
    try {
      final url = await storageService.uploadProfileImage(
        userId: admin.adminID,
        file: File(picked.path),
        context: context,
      );
      if (url != null) {
        await service.updateAdmin(admin.adminID, {'profilePic': url});
        await ref.read(authProvider.notifier).loadCurrentUser();
      }
    } finally {
      if (mounted) setState(() => isUploadingImage = false);
    }
  }

  Future<void> logout() async {
    await ref.read(authProvider.notifier).logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // FIX: watch the provider itself, not .notifier, so the screen
    // actually rebuilds when profile data changes.
    final admin = ref.watch(authProvider).admin;

    if (!loaded || admin == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            ElevateHeader(
              title: "Your Info",
              subTitle: "Let's Discover Yourself",
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 40,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: isUploadingImage ? null : pickAndUploadImage,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFE6E6E6),
                                image: admin.profilePic.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(admin.profilePic),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: admin.profilePic.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                            if (isUploadingImage)
                              const CircularProgressIndicator(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextBox(
                        text: admin.name.isNotEmpty ? admin.name : "Admin",
                        backgroundColor: const Color.fromARGB(
                          255,
                          230,
                          230,
                          230,
                        ),
                        textAlign: TextAlign.center,
                        width: 280,
                        height: 50,
                        textColor: ElevateColor.lightgray,
                        borderRadius: 50,
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        hintText: "About",
                        hintWeight: FontWeight.bold,
                        controller: aboutController,
                        cursorColor: ElevateColor.black,
                        underlineColor: ElevateColor.black,
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        hintText: "Location",
                        hintWeight: FontWeight.bold,
                        controller: locationController,
                        cursorColor: ElevateColor.black,
                        underlineColor: ElevateColor.black,
                      ),
                      const SizedBox(height: 30),
                      isSaving
                          ? const CircularProgressIndicator()
                          : TextButtonGradient(
                              text: "Save Changes",
                              height: 50,
                              textSize: 14,
                              textWeight: FontWeight.w400,
                              borderRadius: 50,
                              onTap: saveProfile,
                            ),
                      const SizedBox(height: 25),
                      TexxtButton(
                        text: "Forget Password",
                        height: 50,
                        textSize: 14,
                        textColor: ElevateColor.whitegray,
                        textWeight: FontWeight.w400,
                        borderRadius: 50,
                        backgroundColor: Colors.transparent,
                        borderColor: ElevateColor.white,
                        borderWidth: 0,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminForgetScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 25),
                      TextButtonGradient(
                        text: "Log out",
                        height: 50,
                        textSize: 14,
                        textWeight: FontWeight.w400,
                        borderRadius: 50,
                        onTap: logout,
                      ),
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
