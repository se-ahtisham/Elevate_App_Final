import 'dart:convert';
import 'package:elevate_app/Data_Model_Classes/api_skill_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SkillApiServices {
  static String apiKey = dotenv.env['Top_Skill_Ai_API_KEY'] ?? '';

  static const String _host = "chatgpt-42.p.rapidapi.com";

  static const String _url =
      "https://chatgpt-42.p.rapidapi.com/conversationgpt4-2";

  static Future<List<SkillModel>> fetchTrendingSkills() async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          "Content-Type": "application/json",
          "x-rapidapi-key": apiKey,
          "x-rapidapi-host": _host,
        },
        body: jsonEncode({
          "messages": [
            {
              "role": "user",
              "content":
                  "Give me exactly 20 highest paying in-demand tech jobs and skills of 2026. "
                  "Return ONLY valid JSON array in this format: "
                  "[{"
                  "\"title\":\"AI Engineer\","
                  "\"company\":\"Google\","
                  "\"location\":\"USA\","
                  "\"salary_start\":80000,"
                  "\"salary_end\":150000"
                  "}] "
                  "No explanation. No markdown. No extra text.",
            },
          ],
          "temperature": 0.9,
          "top_p": 0.9,
          "max_tokens": 500,
          "web_access": false,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        String content = data["result"] ?? data["message"] ?? "";

        content = content
            .replaceAll("```json", "")
            .replaceAll("```", "")
            .trim();

        final List<dynamic> parsed = jsonDecode(content);

        return parsed.map((e) => SkillModel.fromJson(e)).toList();
      } else {
        throw Exception("API Error: ${response.body}");
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }
}
