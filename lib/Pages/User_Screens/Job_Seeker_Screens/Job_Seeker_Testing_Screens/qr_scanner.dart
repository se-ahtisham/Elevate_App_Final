import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Testing_Screens/test_web_config.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => QrScannerState();
}

class QrScannerState extends State<QrScanner> {
  final MobileScannerController controller = MobileScannerController();
  bool handled = false;
  bool torchOn = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> onDetect(BarcodeCapture capture) async {
    if (handled) return;
    final code = capture.barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    handled = true;
    await controller.stop();

    // Placeholder logic: treat the scanned value as a raw testID.
    // If the QR later encodes a full URL instead, swap this for:
    //   final uri = Uri.tryParse(code);
    //   if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) { ... }
    final uri = TestWebConfig.buildTestUrl(code);

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't open that test link.")),
      );
      handled = false;
      await controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(controller: controller, onDetect: onDetect),

          IgnorePointer(
            child: CustomPaint(
              size: Size.infinite,
              painter: _ViewfinderOverlay(),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const CustomText(
                    text: "Scan Test QR",
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  IconButton(
                    icon: Icon(
                      torchOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: () {
                      controller.toggleTorch();
                      setState(() => torchOn = !torchOn);
                    },
                  ),
                ],
              ),
            ),
          ),

          Align(
            alignment: const Alignment(0, 0.78),
            child: CustomText(
              text: "Align the QR code within the frame",
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewfinderOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final boxSize = size.width * 0.7;
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: boxSize,
      height: boxSize,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(24));

    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.55);
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, overlayPaint);

    final borderPaint = Paint()
      ..color = const Color(0xFFD97706)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}