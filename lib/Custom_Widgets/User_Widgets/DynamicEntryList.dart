import 'package:flutter/material.dart';

class DynamicEntryList extends StatelessWidget {
  final String title;
  final List<Map<String, TextEditingController>> entries;
  final List<Map<String, String>> fields;
  final VoidCallback onAdd;
  final void Function(int index) onRemove;

  const DynamicEntryList({
    super.key,
    required this.title,
    required this.entries,
    required this.fields,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 13)),
            GestureDetector(onTap: onAdd, child: const Icon(Icons.add)),
          ],
        ),

        const SizedBox(height: 10),
        for (int i = 0; i < entries.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                // Text fields
                for (var field in fields)
                  TextField(
                    controller: entries[i][field['key']],
                    decoration: InputDecoration(hintText: field['hint']),
                  ),

                // Delete button
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => onRemove(i),
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
