import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Message_Box/messageBox.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Database/Online_Database/auth_provider.dart';
import 'package:elevate_app/Pages/Login_Screens/login_screen.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminForgetScreen extends ConsumerStatefulWidget {
  const AdminForgetScreen({super.key});

  @override
  ConsumerState<AdminForgetScreen> createState() => AdminForgetScreenState();
}

class AdminForgetScreenState extends ConsumerState<AdminForgetScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> sendResetLink() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const Messagebox(message: "Please enter your email."),
      );
      return;
    }

    final notifier = ref.read(authProvider.notifier);
    final success = await notifier.forgotPassword(email);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => Messagebox(
        message: success
            ? "Password reset link sent. Check your inbox."
            : ref.read(authProvider).errorMessage ??
                  "Failed to send reset link.",
        onOkTap: success ? goBack : null,
      ),
    );
  }

  void goBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            Stack(
              children: [
                const ElevateHeader(
                  title: "Your Info",
                  subTitle: "Let's Discover Yourself",
                ),
                Positioned(
                  top: 170,
                  right: 120,
                  child: TexxtButton(
                    text: "Back",
                    width: 120,
                    height: 50,
                    textSize: 12,
                    textWeight: FontWeight.w500,
                    textColor: const Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: const Color.fromARGB(224, 114, 114, 114),
                    borderColor: const Color(0xFF8B8B8B),
                    borderRadius: 80,
                    borderWidth: 1,
                    onTap: goBack,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 40,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Email",
                        fontSize: 12,
                        color: ElevateColor.whitegray,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        hintText: "Enter your email",
                        hintWeight: FontWeight.w400,
                        controller: emailController,
                        cursorColor: ElevateColor.black,
                        underlineColor: ElevateColor.black,
                      ),
                      const SizedBox(height: 30),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : TextButtonGradient(
                              text: "Send Reset Link",
                              height: 50,
                              textSize: 14,
                              textWeight: FontWeight.w400,
                              borderRadius: 50,
                              onTap: sendResetLink,
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
