import 'package:flutter/material.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';

class CustomDropDown extends StatelessWidget {
  final String hintText;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;

  final double height;
  final double width;
  final double borderRadius;
  final double borderWidth;

  final double hintTextSize;
  final double textSize;

  final FontWeight textWeight;
  final TextAlign textAlign;

  final Color backgroundColor;
  final Color borderColor;
  final Color hintTextColor;
  final Color textColor;
  final Color dropdownColor;

  final EdgeInsets padding;

  const CustomDropDown({
    super.key,
    required this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,

    this.height = 50,
    this.width = double.infinity,
    this.borderRadius = 12,
    this.borderWidth = 1,

    this.hintTextSize = 14,
    this.textSize = 14,

    this.textWeight = FontWeight.normal,
    this.textAlign = TextAlign.start,

    this.backgroundColor = Colors.white,
    this.borderColor = Colors.grey,
    this.hintTextColor = Colors.grey,
    this.textColor = Colors.black,
    this.dropdownColor = Colors.white,

    this.padding = const EdgeInsets.symmetric(horizontal: 15),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: dropdownColor,

        hint: CustomText(
          text: hintText,
          fontSize: hintTextSize,
          color: hintTextColor,
          fontWeight: textWeight,
          textAlign: textAlign,
        ),

        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: CustomText(
              text: item,
              fontSize: textSize,
              color: textColor,
              fontWeight: textWeight,
              textAlign: textAlign,
            ),
          );
        }).toList(),

        onChanged: onChanged,
      ),
    );
  }
}
