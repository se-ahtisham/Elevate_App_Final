  import 'package:elevate_app/Pages/Splash_Screens/job_splash.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // ── Timing constants (tweak as you like) ──
  static const Duration _fadeInDuration = Duration(milliseconds: 1200);
  static const Duration _holdDuration = Duration(milliseconds: 1500);
  static const Duration _fadeOutDuration = Duration(milliseconds: 900);

  @override
  void initState() {
    super.initState();

    final int totalMs =
        _fadeInDuration.inMilliseconds +
        _holdDuration.inMilliseconds +
        _fadeOutDuration.inMilliseconds;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMs),
    );

    final double fadeInWeight = _fadeInDuration.inMilliseconds.toDouble();
    final double holdWeight = _holdDuration.inMilliseconds.toDouble();
    final double fadeOutWeight = _fadeOutDuration.inMilliseconds.toDouble();

    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: fadeInWeight,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: holdWeight),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: fadeOutWeight,
      ),
    ]).animate(_controller);

    _controller.forward().then((_) => _navigateToHome());
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => JobSplash(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'lib/Resources/Images/splash_background.jpeg',
            fit: BoxFit.cover,
          ),

          Container(color: Colors.black.withAlpha(25)),

          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                'lib/Resources/Images/app_logo.png',
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
