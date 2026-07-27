import 'dart:convert';
import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserColdEmail extends StatefulWidget {
  final String jobTitle;
  final String companyName;

  const UserColdEmail({
    super.key,
    this.jobTitle = "UI/UX Designer",
    this.companyName = "Microsoft",
  });

  @override
  State<UserColdEmail> createState() => _UserColdEmailState();
}

class _UserColdEmailState extends State<UserColdEmail> {
  String get _apiKey => dotenv.env['GROQ_API_KEY'] ?? '';

  String emailBody = "";
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    generateColdEmail();
  }

  String get jobTitleFallback =>
      widget.jobTitle.isNotEmpty ? widget.jobTitle : "the open";

  Future<void> generateColdEmail() async {
    if (!mounted) return;

    if (_apiKey.isEmpty) {
      setState(() {
        errorMessage = "API key not configured. Add GROQ_API_KEY=your_key_here to your .env file. Get a free key at console.groq.com";
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse("https://api.groq.com/openai/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_apiKey",
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": [
            {
              "role": "system",
              "content":
                  "You write short, professional cold emails for job seekers reaching out to companies. Keep it under 150 words, no subject line, no placeholders like [Your Name].",
            },
            {
              "role": "user",
              "content":
                  "Write a cold email for a $jobTitleFallback position at ${widget.companyName}.",
            },
          ],
          "temperature": 0.7,
        }),
      );

      if (response.statusCode != 200) {
        final errorBody = jsonDecode(response.body);
        final errorMsg = errorBody['error']?['message'] ?? 'Unknown error';
        throw Exception("API error ${response.statusCode}: $errorMsg");
      }

      final data = jsonDecode(response.body);
      final text = data["choices"]?[0]?["message"]?["content"]
          ?.toString()
          .trim();

      if (text == null || text.isEmpty) {
        throw Exception("Empty response from AI");
      }

      if (!mounted) return;
      setState(() {
        emailBody = text;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = "Couldn't generate email. Please try again.";
        isLoading = false;
      });
    }
  }

  void copyToClipboard() {
    if (emailBody.isEmpty) return;
    Clipboard.setData(ClipboardData(text: emailBody));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Copied to clipboard!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ElevateColor.white,
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ElevateHeader(
              title: "Opportunities",
              subTitle: "Powered by AI",
              titleSize: 25,
              subtitleSize: 20,
              showBackButton: true,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    CustomText(
                      text: "Join Our Team as a ${widget.jobTitle}",
                      fontSize: 19,
                      color: const Color.fromARGB(255, 99, 99, 99),
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      lineHeight: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),

                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                      )
                    else if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: errorMessage!,
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(height: 12),
                            TexxtButton(
                              text: "Retry",
                              height: 44,
                              width: 120,
                              textSize: 13,
                              textColor: Colors.black,
                              textWeight: FontWeight.w500,
                              borderRadius: 30,
                              backgroundColor: Colors.transparent,
                              borderColor: Colors.black,
                              borderWidth: 1,
                              onTap: generateColdEmail,
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: emailBody,
                            fontSize: 12,
                            color: const Color.fromARGB(255, 99, 99, 99),
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.left,
                            lineHeight: 1.5,
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TexxtButton(
                              text: "Copy",
                              height: 40,
                              width: 100,
                              textSize: 12,
                              textColor: Colors.black,
                              textWeight: FontWeight.w500,
                              borderRadius: 30,
                              backgroundColor: Colors.transparent,
                              borderColor: Colors.black,
                              borderWidth: 1,
                              onTap: copyToClipboard,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 30),
                    TextButtonGradient(
                      text: "Regenerate",
                      height: 50,
                      textSize: 14,
                      textWeight: FontWeight.w400,
                      borderRadius: 50,
                      onTap: isLoading ? null : generateColdEmail,
                    ),
                    const SizedBox(height: 15),
                    TexxtButton(
                      text: "Back",
                      height: 50,
                      textSize: 14,
                      textColor: ElevateColor.gray,
                      textWeight: FontWeight.w400,
                      borderRadius: 50,
                      backgroundColor: Colors.transparent,
                      borderColor: ElevateColor.gray,
                      borderWidth: 1,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 30),
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
