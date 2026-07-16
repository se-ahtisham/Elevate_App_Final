import 'package:elevate_app/Animation/slide_left_route.dart';
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

class ForgetPasswordScreen extends ConsumerStatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ConsumerState<ForgetPasswordScreen> createState() =>
      _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends ConsumerState<ForgetPasswordScreen> {
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
        onOkTap: success
            ? () => Navigator.pushReplacement(
                context,
                SlideLeftRoute(page: LoginScreen()),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: ElevateColor.white,
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            Stack(
              children: [
                ElevateHeader(
                  title: "Lost Access?",
                  titleSize: 30,
                  subTitle: "Let's reconnect you with your account in seconds.",
                  subtitleSize: 14,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70, left: 250),
                  child: TexxtButton(
                    text: "Go To Login",
                    textSize: 12,
                    textColor: Colors.black,
                    backgroundColor: Colors.white,
                    borderRadius: 20,
                    height: 40,
                    width: 150,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        SlideLeftRoute(page: LoginScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),

                      CustomText(
                        text: "Email",
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: CustomTextField(
                            hintText: "Enter your email",
                            controller: emailController,
                            cursorColor: ElevateColor.black,
                            underlineColor: Colors.transparent,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : TextButtonGradient(
                              text: "Send Reset Link",
                              height: 50,
                              textSize: 16,
                              textWeight: FontWeight.w500,
                              borderRadius: 30,
                              onTap: sendResetLink,
                            ),

                      const SizedBox(height: 20),
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
