import 'package:flutter/material.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';

class AdminCard extends StatelessWidget {
  final String topText;
  final String bottomText;
  final int count;

  const AdminCard({
    super.key,
    required this.topText,
    required this.bottomText,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Row(
        children: [

          // 🔹 LEFT CONTAINER
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration:  BoxDecoration(
                color: Color(0xFFEAEAEA),
 border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                
                  CustomText(
                    text: topText,
                    fontSize: 20,
                    color: const Color.fromARGB(214, 36, 36, 36),
                    fontWeight: FontWeight.w400,
                    lineHeight: 1.0,
                  ),

                  const SizedBox(height: 5),

                 
                  CustomText(
                    text: bottomText,
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    lineHeight: 1.0,
                  ),
                ],
              ),
            ),
          ),

          // 🔹 RIGHT CONTAINER
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3A3A3A), Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: CustomText(
                text: "$count",
                fontSize: 34,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                lineHeight: 1.0,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}