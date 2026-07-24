// lib/services/api_status_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiEndpointStatus {
  final String environment;
  final String name;
  final String url;
  final String method;
  bool isRunning;
  int? statusCode;
  String? responseMessage;

  ApiEndpointStatus({
    required this.environment,
    required this.name,
    required this.url,
    required this.method,
    this.isRunning = false,
    this.statusCode,
    this.responseMessage,
  });
}

class ApiStatusChecker {
  static const String liveBaseUrl = 'https://elevate-backend-rtdg.onrender.com';
  static const String localBaseUrl = 'http://127.0.0.1:8000';

  static Future<ApiEndpointStatus> checkEndpoint({
    required String environment,
    required String name,
    required String url,
    required String method,
    Map<String, dynamic>? body,
  }) async {
    try {
      http.Response response;
      final uri = Uri.parse(url);

      if (method == 'POST') {
        response = await http
            .post(
              uri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(body ?? {}),
            )
            .timeout(const Duration(seconds: 15));
      } else {
        response = await http.get(uri).timeout(const Duration(seconds: 15));
      }

      bool isOk = response.statusCode >= 200 && response.statusCode < 300;

      return ApiEndpointStatus(
        environment: environment,
        name: name,
        url: url,
        method: method,
        isRunning: isOk,
        statusCode: response.statusCode,
        responseMessage: response.body,
      );
    } catch (e) {
      return ApiEndpointStatus(
        environment: environment,
        name: name,
        url: url,
        method: method,
        isRunning: false,
        statusCode: 0,
        responseMessage: e.toString(),
      );
    }
  }

  static Future<List<ApiEndpointStatus>> checkAllEndpoints() async {
    List<ApiEndpointStatus> results = [];

    // Validated payload based on FastAPI schema error logs
    final Map<String, dynamic> recordAnswerBody = {
      'user_id': 'admin_test',
      'skill': 'Flutter',
      'level': 'Beginner',
      'mode': 'pure',
      'topic': 'Widgets',
      'difficulty_level': 1, // Changed from string 'easy' to int 1
      'question_type': 'mcq', // Added required missing field
      'was_correct': true,
      'is_correct': true,
      'question_id': 'test_q_101',
      'selected_answer': 'StatelessWidget',
      'user_answer': 'StatelessWidget',
    };

    // ==========================================
    // 🌐 LIVE PRODUCTION SERVER (RENDER)
    // ==========================================

    // 1. Health Check
    results.add(
      await checkEndpoint(
        environment: 'Live (Render)',
        name: 'Health Check',
        url: '$liveBaseUrl/health',
        method: 'GET',
      ),
    );

    // 2. Generate Question
    results.add(
      await checkEndpoint(
        environment: 'Live (Render)',
        name: 'Generate Question',
        url: '$liveBaseUrl/generate-question',
        method: 'POST',
        body: {
          'user_id': 'admin_test',
          'skill': 'Flutter',
          'level': 'Beginner',
          'mode': 'pure',
          'question_type': 'mcq',
        },
      ),
    );

    // 3. Record Answer
    var recordAnswerResultLive = await checkEndpoint(
      environment: 'Live (Render)',
      name: 'Record Answer',
      url: '$liveBaseUrl/record_answer',
      method: 'POST',
      body: recordAnswerBody,
    );
    if (!recordAnswerResultLive.isRunning &&
        recordAnswerResultLive.statusCode == 404) {
      recordAnswerResultLive = await checkEndpoint(
        environment: 'Live (Render)',
        name: 'Record Answer',
        url: '$liveBaseUrl/record-answer',
        method: 'POST',
        body: recordAnswerBody,
      );
    }
    results.add(recordAnswerResultLive);

    // 4. Get AI Logs
    var aiLogsResultLive = await checkEndpoint(
      environment: 'Live (Render)',
      name: 'Get AI Logs',
      url: '$liveBaseUrl/get_ai_logs',
      method: 'GET',
    );
    if (!aiLogsResultLive.isRunning && aiLogsResultLive.statusCode == 404) {
      aiLogsResultLive = await checkEndpoint(
        environment: 'Live (Render)',
        name: 'Get AI Logs',
        url: '$liveBaseUrl/ai-logs',
        method: 'GET',
      );
    }
    results.add(aiLogsResultLive);

    // ==========================================
    // 💻 LOCAL DEVELOPMENT SERVER
    // ==========================================

    // 5. Health Check
    results.add(
      await checkEndpoint(
        environment: 'Local Machine',
        name: 'Health Check',
        url: '$localBaseUrl/health',
        method: 'GET',
      ),
    );

    // 6. Generate Question
    results.add(
      await checkEndpoint(
        environment: 'Local Machine',
        name: 'Generate Question',
        url: '$localBaseUrl/generate-question',
        method: 'POST',
        body: {
          'user_id': 'admin_test',
          'skill': 'Flutter',
          'level': 'Beginner',
          'mode': 'pure',
          'question_type': 'mcq',
        },
      ),
    );

    // 7. Record Answer
    var recordAnswerResultLocal = await checkEndpoint(
      environment: 'Local Machine',
      name: 'Record Answer',
      url: '$localBaseUrl/record_answer',
      method: 'POST',
      body: recordAnswerBody,
    );
    if (!recordAnswerResultLocal.isRunning &&
        recordAnswerResultLocal.statusCode == 404) {
      recordAnswerResultLocal = await checkEndpoint(
        environment: 'Local Machine',
        name: 'Record Answer',
        url: '$localBaseUrl/record-answer',
        method: 'POST',
        body: recordAnswerBody,
      );
    }
    results.add(recordAnswerResultLocal);

    // 8. Get AI Logs
    var aiLogsResultLocal = await checkEndpoint(
      environment: 'Local Machine',
      name: 'Get AI Logs',
      url: '$localBaseUrl/get_ai_logs',
      method: 'GET',
    );
    if (!aiLogsResultLocal.isRunning && aiLogsResultLocal.statusCode == 404) {
      aiLogsResultLocal = await checkEndpoint(
        environment: 'Local Machine',
        name: 'Get AI Logs',
        url: '$localBaseUrl/ai-logs',
        method: 'GET',
      );
    }
    results.add(aiLogsResultLocal);

    return results;
  }
}
