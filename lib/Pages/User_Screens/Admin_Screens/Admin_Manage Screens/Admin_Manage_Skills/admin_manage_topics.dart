
import 'package:elevate_app/topic_model.dart';
import 'package:elevate_app/topic_service.dart';
import 'package:flutter/material.dart';
import 'package:elevate_app/Custom_Widgets/Header/elevate_header.dart';
import 'package:elevate_app/Custom_Widgets/Text/custom_text.dart';
import 'package:elevate_app/Custom_Widgets/Test_Fields/custom_Text_Field.dart';

class AdminManageTopics extends StatefulWidget {
  final String skillName;

  const AdminManageTopics({super.key, required this.skillName});

  @override
  State<AdminManageTopics> createState() => AdminManageTopicsState();
}

class AdminManageTopicsState extends State<AdminManageTopics> {
  final TopicService topicService = TopicService();

  bool isLoading = true;
  bool isSaving = false;

  List<TopicModel> existingTopics = [];
  final List<Map<String, dynamic>> newRows = [];

  final List<String> levelOptions = ['Beginner', 'Intermediate', 'Advanced'];
  final List<String> experienceLevelOptions = [
    '0-1 yrs',
    '1-3 yrs',
    '3-5 yrs',
    '5-10 yrs',
    '10+ yrs',
  ];
  final List<String> modeOptions = ['pure', 'vibe', 'experience'];

  @override
  void initState() {
    super.initState();
    loadTopics();
  }

  @override
  void dispose() {
    for (final row in newRows) {
      row['topicController'].dispose();
    }
    super.dispose();
  }

  Future<void> loadTopics() async {
    setState(() => isLoading = true);
    existingTopics = await topicService.getTopicsForSkill(widget.skillName);
    if (mounted) setState(() => isLoading = false);
  }

  void addNewRow() {
    setState(() {
      newRows.add({
        'mode': 'pure',
        'level': 'Beginner',
        'topicController': TextEditingController(),
      });
    });
  }

  void removeNewRow(int index) {
    setState(() {
      newRows[index]['topicController'].dispose();
      newRows.removeAt(index);
    });
  }

  Future<void> deleteExistingTopic(String topicId) async {
    await topicService.deleteTopic(topicId);
    loadTopics();
  }

  Future<void> saveAllNewRows() async {
    setState(() => isSaving = true);

    for (final row in newRows) {
      final topicText = row['topicController'].text.trim();
      if (topicText.isEmpty) continue;

      await topicService.addTopic(
        widget.skillName,
        row['level'],
        row['mode'],
        topicText,
      );
    }

    for (final row in newRows) {
      row['topicController'].dispose();
    }
    newRows.clear();

    if (mounted) setState(() => isSaving = false);
    await loadTopics();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Topics saved')));
    }
  }

  Widget existingTopicRow(TopicModel topic) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: topic.topic,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 4),
                CustomText(
                  text: '${topic.mode} · ${topic.level}',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 170, 170, 170),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => deleteExistingTopic(topic.id),
            child: const Icon(Icons.delete, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget newRowCard(int index) {
    final row = newRows[index];
    final currentLevels = row['mode'] == 'experience'
        ? experienceLevelOptions
        : levelOptions;

    if (!currentLevels.contains(row['level'])) {
      row['level'] = currentLevels[0];
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 75, 75, 75)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            hintText: 'Topic name (e.g. loops)',
            controller: row['topicController'],
            cursorColor: Colors.black,
            underlineColor: const Color.fromARGB(131, 128, 128, 128),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: row['mode'],
                  isExpanded: true,
                  items: modeOptions
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => row['mode'] = value!);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButton<String>(
                  value: row['level'],
                  isExpanded: true,
                  items: currentLevels
                      .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => row['level'] = value!);
                  },
                ),
              ),
              GestureDetector(
                onTap: () => removeNewRow(index),
                child: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.delete, color: Colors.black54, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ElevateHeader(
            title: "Elevate",
            subTitle: "Manage Topics · ${widget.skillName}",
            titleSize: 40,
            subtitleSize: 18,
            showBackButton: true,
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CustomText(
                              text: "Existing Topics",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              textAlign: TextAlign.left,
                            ),
                            GestureDetector(
                              onTap: addNewRow,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        if (existingTopics.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: CustomText(
                              text: "No topics yet for this skill.",
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                              textAlign: TextAlign.left,
                            ),
                          )
                        else
                          ...existingTopics.map(existingTopicRow),
                        if (newRows.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const CustomText(
                            text: "New Topics",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 14),
                          ...List.generate(newRows.length, newRowCard),
                        ],
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (isSaving || newRows.isEmpty)
                                ? null
                                : saveAllNewRows,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: CustomText(
                              text: isSaving ? "SAVING..." : "SAVE TOPICS",
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}