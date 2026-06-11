import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';
import 'package:flutter/material.dart';

class DynamicEntryList extends StatelessWidget {
  final String title;
  final List<Map<String, TextEditingController>> entries;
  final List<Map<String, String>> fields;

  const DynamicEntryList({
    super.key,
    required this.title,
    required this.entries,
    required this.fields,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 20),

        for (int i = 0; i < entries.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 30),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                for (var field in fields)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CustomTextField(
                      controller: entries[i][field['key']]!,
                      hintText: field['hint']!,
                      cursorColor: Colors.black,
                      underlineColor: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
