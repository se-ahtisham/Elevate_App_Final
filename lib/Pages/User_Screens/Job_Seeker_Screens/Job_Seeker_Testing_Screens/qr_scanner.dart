import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_app/Pages/User_Screens/Job_Seeker_Screens/Job_Seeker_Testing_Screens/device_linked_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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

    // 1. Parse the scanned value as a URI
    final uri = Uri.tryParse(code);
    if (uri == null) {
      _showError("Invalid QR code scanned.");
      return;
    }

    // 2. Extract the session ID parameter 's'
    final sessionId =
        uri.queryParameters['s'] ??
        (code.startsWith('elevate_login_') ? code : null);
    if (sessionId == null || sessionId.isEmpty) {
      _showError("Not a valid Elevate login session.");
      return;
    }

    // 3. Get the current logged-in user from Firebase
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showError("Please sign into your Elevate mobile app account first.");
      return;
    }

    // Show a loading dialog during pairing
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Color(0xFFD97706)),
        ),
      );
    }

    try {
      final userEmail = currentUser.email ?? "";
      final userUid = currentUser.uid;
      final userName =
          currentUser.displayName ??
          (userEmail.contains('@') ? userEmail.split('@')[0] : "Candidate");

      // 4. Update the Firestore session document to "paired"
      await FirebaseFirestore.instance
          .collection('qr_sessions')
          .doc(sessionId)
          .set({
            'status': 'paired',
            'email': userEmail,
            'name': userName,
            'displayName': userName,
            'jobSeekerID': userUid,
            'pairedAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DeviceLinkedScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      _showError("Failed to pair device: $e");
    }
  }

  void _showError(String message) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
    handled = false;
    await controller.start();
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const CustomText(
                    text: "Scan Login QR",
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
              color: Colors.white.withOpacity(0.8),
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

    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.55);
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
