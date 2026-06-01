
import 'package:flutter/material.dart';

// Animation for screen from right to left
class SlideRightRoute extends PageRouteBuilder {
  SlideRightRoute({required Widget page})
      : super(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}