import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class UserDescriptionShort extends StatelessWidget {
  final String imageURL;
  final String name;
  final String shortDescription;

  const UserDescriptionShort({
    super.key,
    required this.imageURL,
    required this.name,
    this.shortDescription = "",
  });

  ImageProvider? _getImageProvider(String path) {
    if (path.isEmpty) return null;
    if (path.startsWith("http://") || path.startsWith("https://")) {
      return NetworkImage(path);
    }
    return AssetImage(path);
  }

  String _getInitials(String text) {
    if (text.trim().isEmpty) return "?";
    final words = text.trim().split(' ');
    final letters = words.take(2).map((w) => w.isNotEmpty ? w[0] : '');
    return letters.join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final provider = _getImageProvider(imageURL);

    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ElevateColor.lightgray,
            image: provider != null
                ? DecorationImage(
                    image: provider,
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: provider == null
              ? Center(
                  child: Text(
                    _getInitials(name),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: name,
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.left,
                lineHeight: 1.1,
              ),
              if (shortDescription.isNotEmpty) ...[
                const SizedBox(height: 2),
                CustomText(
                  text: shortDescription,
                  fontSize: 11,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.left,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
