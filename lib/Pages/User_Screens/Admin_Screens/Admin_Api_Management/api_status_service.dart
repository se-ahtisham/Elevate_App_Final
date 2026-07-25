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

  // Cap how much of a response body we keep around for display.
  // (e.g. /docs returns a full HTML page, ai-logs could grow large)
  static const int _maxResponseChars = 1000;

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

      String message = response.body;
      if (message.length > _maxResponseChars) {
        message =
            '${message.substring(0, _maxResponseChars)}\n… (truncated, ${response.body.length} chars total)';
      }

      return ApiEndpointStatus(
        environment: environment,
        name: name,
        url: url,
        method: method,
        isRunning: isOk,
        statusCode: response.statusCode,
        responseMessage: message,
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

  /// Tries [primaryUrl] first; if that 404s, falls back to [fallbackUrl].
  /// Useful while the backend's exact route naming (underscore vs dash) is
  /// still being confirmed.
  static Future<ApiEndpointStatus> _checkWithFallback({
    required String environment,
    required String name,
    required String primaryUrl,
    required String fallbackUrl,
    required String method,
    Map<String, dynamic>? body,
  }) async {
    var result = await checkEndpoint(
      environment: environment,
      name: name,
      url: primaryUrl,
      method: method,
      body: body,
    );
    if (!result.isRunning && result.statusCode == 404) {
      result = await checkEndpoint(
        environment: environment,
        name: name,
        url: fallbackUrl,
        method: method,
        body: body,
      );
    }
    return result;
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

    // Best-guess payloads for the evaluate endpoints, following the same
    // field naming pattern confirmed on record-answer. These haven't been
    // schema-validated yet — if the card shows a 422, the Response Body
    // will list exactly which fields the backend actually expects, same
    // way record-answer's payload above was worked out.
    final Map<String, dynamic> evaluateMcqBody = {
      'user_id': 'admin_test',
      'skill': 'Flutter',
      'level': 'Beginner',
      'topic': 'Widgets',
      'question_type': 'mcq',
      'question_id': 'test_q_101',
      'selected_answer': 'StatelessWidget',
      'correct_answer': 'StatelessWidget',
    };

    final Map<String, dynamic> evaluateTheoryBody = {
      'user_id': 'admin_test',
      'skill': 'Flutter',
      'level': 'Beginner',
      'topic': 'Widgets',
      'question_type': 'theory',
      'question_id': 'test_q_102',
      'user_answer':
          'A StatelessWidget is immutable and does not depend on any mutable state.',
    };

    final Map<String, dynamic> evaluateCodingBody = {
      'user_id': 'admin_test',
      'skill': 'Flutter',
      'level': 'Beginner',
      'topic': 'Widgets',
      'question_type': 'coding',
      'question_id': 'test_q_103',
      'language': 'dart',
      'user_code':
          'class MyWidget extends StatelessWidget {\n  @override\n  Widget build(BuildContext context) => Container();\n}',
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
    results.add(
      await _checkWithFallback(
        environment: 'Live (Render)',
        name: 'Record Answer',
        primaryUrl: '$liveBaseUrl/record_answer',
        fallbackUrl: '$liveBaseUrl/record-answer',
        method: 'POST',
        body: recordAnswerBody,
      ),
    );

    // 4. Evaluate MCQ
    results.add(
      await checkEndpoint(
        environment: 'Live (Render)',
        name: 'Evaluate MCQ',
        url: '$liveBaseUrl/evaluate-mcq',
        method: 'POST',
        body: evaluateMcqBody,
      ),
    );

    // 5. Evaluate Theory
    results.add(
      await checkEndpoint(
        environment: 'Live (Render)',
        name: 'Evaluate Theory',
        url: '$liveBaseUrl/evaluate-theory',
        method: 'POST',
        body: evaluateTheoryBody,
      ),
    );

    // 6. Evaluate Coding
    results.add(
      await checkEndpoint(
        environment: 'Live (Render)',
        name: 'Evaluate Coding',
        url: '$liveBaseUrl/evaluate-coding',
        method: 'POST',
        body: evaluateCodingBody,
      ),
    );

    // 7. Get AI Logs
    results.add(
      await _checkWithFallback(
        environment: 'Live (Render)',
        name: 'Get AI Logs',
        primaryUrl: '$liveBaseUrl/get_ai_logs',
        fallbackUrl: '$liveBaseUrl/ai-logs',
        method: 'GET',
      ),
    );

    // 8. Interactive Docs (Swagger)
    results.add(
      await checkEndpoint(
        environment: 'Live (Render)',
        name: 'Interactive Docs (Swagger)',
        url: '$liveBaseUrl/docs',
        method: 'GET',
      ),
    );

    // ==========================================
    // 💻 LOCAL DEVELOPMENT SERVER
    // ==========================================

    // 1. Health Check
    results.add(
      await checkEndpoint(
        environment: 'Local Machine',
        name: 'Health Check',
        url: '$localBaseUrl/health',
        method: 'GET',
      ),
    );

    // 2. Generate Question
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

    // 3. Record Answer
    results.add(
      await _checkWithFallback(
        environment: 'Local Machine',
        name: 'Record Answer',
        primaryUrl: '$localBaseUrl/record_answer',
        fallbackUrl: '$localBaseUrl/record-answer',
        method: 'POST',
        body: recordAnswerBody,
      ),
    );

    // 4. Evaluate MCQ
    results.add(
      await checkEndpoint(
        environment: 'Local Machine',
        name: 'Evaluate MCQ',
        url: '$localBaseUrl/evaluate-mcq',
        method: 'POST',
        body: evaluateMcqBody,
      ),
    );

    // 5. Evaluate Theory
    results.add(
      await checkEndpoint(
        environment: 'Local Machine',
        name: 'Evaluate Theory',
        url: '$localBaseUrl/evaluate-theory',
        method: 'POST',
        body: evaluateTheoryBody,
      ),
    );

    // 6. Evaluate Coding
    results.add(
      await checkEndpoint(
        environment: 'Local Machine',
        name: 'Evaluate Coding',
        url: '$localBaseUrl/evaluate-coding',
        method: 'POST',
        body: evaluateCodingBody,
      ),
    );

    // 7. Get AI Logs
    results.add(
      await _checkWithFallback(
        environment: 'Local Machine',
        name: 'Get AI Logs',
        primaryUrl: '$localBaseUrl/get_ai_logs',
        fallbackUrl: '$localBaseUrl/ai-logs',
        method: 'GET',
      ),
    );

    // 8. Interactive Docs (Swagger)
    results.add(
      await checkEndpoint(
        environment: 'Local Machine',
        name: 'Interactive Docs (Swagger)',
        url: '$localBaseUrl/docs',
        method: 'GET',
      ),
    );

    return results;
  }
}
