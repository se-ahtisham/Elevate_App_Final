import 'package:elevate_app/Custom_Widgets/Buttons/texxt_button.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:flutter/material.dart';

class Deletebox extends StatelessWidget {
  final String name;
  final VoidCallback onDelete;

  const Deletebox({super.key, required this.name, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 31, 31, 31),
              Color.fromARGB(255, 65, 65, 65),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('lib/Resources/Images/elevate_logo.png', height: 48),

            const SizedBox(height: 20),

            CustomText(
              text: "Delete $name?",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: TexxtButton(
                    onTap: () => Navigator.pop(context),
                    text: "Cancel",
                    textSize: 14,
                    textWeight: FontWeight.w400,
                    textColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    borderRadius: 50,
                    borderColor: Colors.white,
                  ),
                ),

                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onDelete();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const CustomText(
                      text: "Delete",
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
