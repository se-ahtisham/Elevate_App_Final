// lib/services/api_status_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiEndpointStatus {
  final String name;
  final String url;
  final String method;
  final bool isRunning;
  final int statusCode;
  final String? message;

  ApiEndpointStatus({
    required this.name,
    required this.url,
    required this.method,
    required this.isRunning,
    required this.statusCode,
    this.message,
  });
}

class ApiStatusChecker {
  static const String liveBaseUrl = 'https://elevate-backend-rtdg.onrender.com';
  static const Duration requestTimeout = Duration(seconds: 15);

  // Payloads below match what Swagger actually confirmed each endpoint
  // expects — verified by hand, one endpoint at a time, on 25 Jul 2026.
  static const Map<String, dynamic> recordAnswerPayload = {
    'user_id': 'admin_test',
    'skill': 'Flutter',
    'level': 'Beginner',
    'mode': 'pure',
    'topic': 'Widgets',
    'difficulty_level': 1,
    'question_type': 'mcq',
    'was_correct': true,
  };

  static const Map<String, dynamic> evaluateMcqPayload = {
    'selected_option': 'StatelessWidget',
    'correct_option': 'StatelessWidget',
  };

  static const Map<String, dynamic> evaluateTheoryPayload = {
    'candidate_answer':
        'A StatelessWidget is immutable and does not depend on mutable state.',
    'model_answer':
        'A StatelessWidget is immutable and does not depend on mutable state.',
  };

  static const Map<String, dynamic> evaluateCodingPayload = {
    'source_code': 'def add(a, b):\n    return a + b',
    'language': 'python',
    'test_cases': [
      {'input': '2,3', 'expected_output': '5'},
    ],
  };

  static Future<ApiEndpointStatus> pingEndpoint(
    String name,
    String url,
    String method, [
    Map<String, dynamic>? body,
  ]) async {
    final uri = Uri.parse(url);

    try {
      final response = method == 'POST'
          ? await http
                .post(
                  uri,
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode(body ?? {}),
                )
                .timeout(requestTimeout)
          : await http.get(uri).timeout(requestTimeout);

      final ok = response.statusCode >= 200 && response.statusCode < 300;

      return ApiEndpointStatus(
        name: name,
        url: url,
        method: method,
        isRunning: ok,
        statusCode: response.statusCode,
        message: ok ? null : shorten(response.body),
      );
    } catch (e) {
      return ApiEndpointStatus(
        name: name,
        url: url,
        method: method,
        isRunning: false,
        statusCode: 0,
        message: shorten(e.toString()),
      );
    }
  }

  static String shorten(String text, {int maxLength = 120}) {
    final singleLine = text.replaceAll('\n', ' ').trim();
    if (singleLine.length <= maxLength) return singleLine;
    return '${singleLine.substring(0, maxLength)}…';
  }

  static Future<List<ApiEndpointStatus>> checkAllEndpoints() {
    return Future.wait([
      pingEndpoint('Health Check', '$liveBaseUrl/health', 'GET'),
      pingEndpoint(
        'Generate Question',
        '$liveBaseUrl/generate-question',
        'POST',
        {
          'user_id': 'admin_test',
          'skill': 'Flutter',
          'level': 'Beginner',
          'mode': 'pure',
          'question_type': 'mcq',
        },
      ),
      pingEndpoint(
        'Record Answer',
        '$liveBaseUrl/record-answer',
        'POST',
        recordAnswerPayload,
      ),
      pingEndpoint(
        'Evaluate MCQ',
        '$liveBaseUrl/evaluate-mcq',
        'POST',
        evaluateMcqPayload,
      ),
      pingEndpoint(
        'Evaluate Theory',
        '$liveBaseUrl/evaluate-theory',
        'POST',
        evaluateTheoryPayload,
      ),
      pingEndpoint(
        'Evaluate Coding',
        '$liveBaseUrl/evaluate-coding',
        'POST',
        evaluateCodingPayload,
      ),
      pingEndpoint('AI Logs', '$liveBaseUrl/ai-logs', 'GET'),
      pingEndpoint('Interactive Docs (Swagger)', '$liveBaseUrl/docs', 'GET'),
    ]);
  }
}
