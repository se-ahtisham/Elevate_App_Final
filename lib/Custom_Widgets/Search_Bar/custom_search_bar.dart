import 'package:elevate_app/Resources/Colors/Solid_Colors/solid_colors.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final IconData iconData;
  final double iconSize;
  final Color iconColor;
  final double iconTextSpacing;
  final Color backgroundColor;
  final double borderRadius;
  final Color borderColor;
  final VoidCallback? onTap;
  final Function(String)? onChanged;

  final double height;
  final double? width;
  final double textSize;
  final Color hintTextColor;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    this.controller,
    this.iconData = Icons.search,
    this.iconSize = 24,
    this.height = 60,
    this.width,
    this.textSize = 18,
    this.iconColor = Colors.black,
    this.borderColor = Colors.black,
    this.iconTextSpacing = 10,
    this.backgroundColor = const Color(0xFFF1F1F1),
    this.borderRadius = 40,
    this.onTap,
    this.onChanged,

    // NEW
    this.hintTextColor = Colors.grey,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: widget.borderColor),
      ),
      child: Row(
        children: [
          Icon(widget.iconData, size: widget.iconSize, color: widget.iconColor),

          SizedBox(width: widget.iconTextSpacing),

          Expanded(
            child: TextField(
              controller: _controller,
              cursorColor: ElevateColor.gray,
              onTap: widget.onTap,
              onChanged: (value) {
                setState(() {});

                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
              decoration: InputDecoration(
                hintText: widget.hintText,

                // HINT TEXT COLOR
                hintStyle: TextStyle(
                  color: widget.hintTextColor,
                  fontSize: widget.textSize,
                ),

                border: InputBorder.none,
                isDense: true,
              ),
              style: TextStyle(
                fontSize: widget.textSize,
                color: const Color(0xFF1C1C3A),
              ),
            ),
          ),

          if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _controller.clear();

                setState(() {});

                if (widget.onChanged != null) {
                  widget.onChanged!('');
                }
              },
              child: const Icon(Icons.clear, size: 18, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
