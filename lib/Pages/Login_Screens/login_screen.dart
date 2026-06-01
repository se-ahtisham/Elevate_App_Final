import 'package:elevate_app/Animation/slide_left_route.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Drop_Down_Menu/custom_drop_down.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Pages/Login_Screens/SignUp_Screen.dart';
import 'package:elevate_app/Pages/Login_Screens/forget_password_screen.dart';
import 'package:elevate_app/Pages/admin_main.dart';
import 'package:elevate_app/Pages/company_main.dart';
import 'package:elevate_app/Pages/job_Seeker_main.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:elevate_app/Services/Auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  String? selectedRole;
  List<String> roleOptions = ["Job Seeker", "Company", "Admin"];

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElevateColor.white,
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            ElevateHeader(
              title: "Sign in to your",
              titleSize: 30,
              subTitle: "Account",
              subtitleSize: 20,
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text:
                            "Sign up and unlock a world of endless opportunities and growth.",
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.left,
                      ),

                      SizedBox(height: 40),

                      CustomText(
                        text: "Email",
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: CustomTextField(
                            hintText: "ahtisham@gmail.com",
                            controller: emailController,
                            cursorColor: ElevateColor.black,
                            underlineColor: Colors.transparent,
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      CustomText(
                        text: "Password",
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.left,
                      ),

                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: CustomTextField(
                            hintText: "**************",
                            controller: passwordController,
                            cursorColor: ElevateColor.black,
                            underlineColor: Colors.transparent,
                            obscureText: true,
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      CustomText(
                        text: "Login As",
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.left,
                      ),

                      SizedBox(height: 8),

                      CustomDropDown(
                        hintText: "Job Seeker / Company",
                        items: roleOptions,
                        value: selectedRole,
                        width: double.infinity,
                        borderWidth: 1,
                        backgroundColor: const Color(0xffF2F2F2),
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                          });
                        },
                      ),

                      SizedBox(height: 30),

                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Row(
                          children: [
                            TexxtButton(
                              text: "Forget Password          |        ",
                              textSize: 13,
                              textColor: Colors.black,
                              textWeight: FontWeight.w500,
                              textAlign: TextAlign.center,
                              backgroundColor: Colors.white,
                              onTap: () async {
                                if (emailController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please enter your email"),
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  await ref
                                      .read(authProvider.notifier)
                                      .forgotPassword(
                                        emailController.text.trim(),
                                      );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Password reset email sent. Check your inbox.",
                                      ),
                                    ),
                                  );

                                  Navigator.pushReplacement(
                                    context,
                                    SlideLeftRoute(page: const LoginScreen()),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              },
                            ),
                            SizedBox(width: 10),

                            TexxtButton(
                              text: "Resend Email",
                              textSize: 13,
                              textColor: const Color.fromARGB(255, 4, 103, 253),
                              textWeight: FontWeight.w500,
                              textAlign: TextAlign.center,
                              backgroundColor: Colors.white,
                              onTap: () async {
                                await ref
                                    .read(authProvider.notifier)
                                    .resendVerificationEmail();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Verification email sent."),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30),

                      TextButtonGradient(
                        text: "Log In",
                        height: 50,
                        textSize: 16,
                        textWeight: FontWeight.w500,
                        borderRadius: 30,

                        onTap: () async {
                          if (emailController.text.trim().isEmpty ||
                              passwordController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please enter email and password",
                                ),
                              ),
                            );
                            return;
                          }

                          if (selectedRole == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select a role"),
                              ),
                            );
                            return;
                          }

                          final error = await ref
                              .read(authProvider.notifier)
                              .login(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );

                          if (error != null) {
                            if (error.contains("EMAIL_NOT_VERIFIED")) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please verify your email before logging in.",
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Invalid email or password."),
                                ),
                              );
                            }

                            return;
                          }

                          final user = ref.read(authProvider);

                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("User data not found"),
                              ),
                            );
                            return;
                          }

                          if (user.userType == "JobSeeker") {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => JobSeekerMain(
                                  niche: 'Flutter Developer',
                                  experience: '2 Year',
                                ),
                              ),
                            );
                          } else if (user.userType == "Company") {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => CompanyMain()),
                            );
                          } else if (user.userType == "Admin") {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => AdminMain()),
                            );
                          }
                        },
                      ),

                      SizedBox(height: 20),
                      TexxtButton(
                        text: "Signup",
                        textSize: 13,
                        textColor: Colors.black,
                        textWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                        backgroundColor: Colors.white,
                        borderColor: Colors.black,
                        borderRadius: 30,
                        borderWidth: 1,
                        height: 50,
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            SlideLeftRoute(page: SignUpScreen()),
                          );
                        },
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
