import 'package:flutter/material.dart';

class CustomGradient extends StatelessWidget {
  final List<Color> colors;
  final Alignment begin;
  final Alignment end;

  const CustomGradient({
    super.key,
    required this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: begin, end: end),
      ),
    );
  }
}



