import 'package:flutter/material.dart';

class ElevateGradientColors {

  static const Gradient grayToBlack = LinearGradient(
    colors: [Color.fromARGB(255, 109, 109, 109), Color.fromARGB(255, 0, 0, 0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient purpleToBlack = LinearGradient(
    colors: [Color(0xFFB155FF), Color(0xFF000000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );


 static const Gradient white = LinearGradient(
    colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );




}
