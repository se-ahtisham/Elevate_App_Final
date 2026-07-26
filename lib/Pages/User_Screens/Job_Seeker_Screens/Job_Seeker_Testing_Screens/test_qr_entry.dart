import 'package:elevate_app/Custom_Widgets/Buttons/text_button_gradient.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Testing_Screens/qr_scanner.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class TestQrEntry extends StatelessWidget {
  const TestQrEntry({super.key});

  Future<void> openScanner(BuildContext context) async {
    final status = await Permission.camera.request();
    if (!context.mounted) return;

    if (status.isGranted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const QrScanner()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Camera permission is needed to scan a test QR."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const ElevateHeader(
                title: "Skill Verification",
                subTitle: "Scan. Prove it. Get badged.",
              ),
              const SizedBox(height: 40),

              Image.asset(
                "lib/Animation/QR_Scan.gif",
                width: 180,
                height: 180,
                fit: BoxFit.cover,
              ),

              const SizedBox(height: 24),

              const CustomText(
                text: "Point your camera at the test QR",
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              CustomText(
                text:
                    "Every skill test now lives on the web. Scan the code on your screen to jump straight into it.",
                fontSize: 12,
                color: ElevateColor.gray,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
                lineHeight: 1.4,
              ),

              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextButtonGradient(
                  text: "Scan QR Code",
                  height: 56,
                  textSize: 15,
                  textWeight: FontWeight.w600,
                  borderRadius: 50,
                  onTap: () => openScanner(context),
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
