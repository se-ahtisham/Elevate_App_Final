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
  // expects — verified by hand, one endpoint at a time.
  // NOTE: question_type must be "MCQ" / "Theory" / "Coding" (capitalized) —
  // the backend doesn't normalize case, so lowercase values were silently
  // producing worse results before.
  static const Map<String, dynamic> generateQuestionPayload = {
    'user_id': 'admin_test',
    'skill': 'Flutter',
    'level': 'Beginner',
    'mode': 'pure',
    'question_type': 'MCQ',
  };

  static const Map<String, dynamic> recordAnswerPayload = {
    'user_id': 'admin_test',
    'skill': 'Flutter',
    'level': 'Beginner',
    'mode': 'pure',
    'topic': 'Widgets',
    'difficulty_level': 1,
    'question_type': 'MCQ',
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
    'source_code': 'a, b = input().split(",")\nprint(int(a) + int(b))',
    'language': 'python',
    'test_cases': [
      {'input': '2,3', 'expected_output': '5'},
    ],
  };

  static const Map<String, dynamic> testStartPayload = {
    'user_id': 'admin_test',
    'skill': 'Flutter',
    'mode': 'pure',
  };

  // ---------------------------------------------------------------------
  // Low-level request helpers
  // ---------------------------------------------------------------------

  static Future<http.Response> _rawRequest(
    String url,
    String method, [
    Map<String, dynamic>? body,
  ]) {
    final uri = Uri.parse(url);
    if (method == 'POST') {
      return http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body ?? {}),
          )
          .timeout(requestTimeout);
    }
    return http.get(uri).timeout(requestTimeout);
  }

  static ApiEndpointStatus _statusFromResponse(
    String name,
    String url,
    String method,
    http.Response response,
  ) {
    final ok = response.statusCode >= 200 && response.statusCode < 300;
    return ApiEndpointStatus(
      name: name,
      url: url,
      method: method,
      isRunning: ok,
      statusCode: response.statusCode,
      message: ok ? null : shorten(response.body),
    );
  }

  static Future<ApiEndpointStatus> pingEndpoint(
    String name,
    String url,
    String method, [
    Map<String, dynamic>? body,
  ]) async {
    try {
      final response = await _rawRequest(url, method, body);
      return _statusFromResponse(name, url, method, response);
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

  // ---------------------------------------------------------------------
  // Chained /test/* flow — these four depend on each other, so they can't
  // just be pinged independently like the rest. start -> next-question ->
  // submit-answer -> result, passing the session_id along each step.
  // ---------------------------------------------------------------------

  static List<ApiEndpointStatus> _skippedTestFlowRemainder(String reason) {
    return [
      ApiEndpointStatus(
        name: 'Test Next Question',
        url: '$liveBaseUrl/test/next-question',
        method: 'POST',
        isRunning: false,
        statusCode: 0,
        message: reason,
      ),
      ApiEndpointStatus(
        name: 'Test Submit Answer',
        url: '$liveBaseUrl/test/submit-answer',
        method: 'POST',
        isRunning: false,
        statusCode: 0,
        message: reason,
      ),
      ApiEndpointStatus(
        name: 'Test Result',
        url: '$liveBaseUrl/test/result/{session_id}',
        method: 'GET',
        isRunning: false,
        statusCode: 0,
        message: reason,
      ),
    ];
  }

  static Future<List<ApiEndpointStatus>> _checkTestFlow() async {
    final results = <ApiEndpointStatus>[];
    final startUrl = '$liveBaseUrl/test/start';

    // Step 1: /test/start
    http.Response startResponse;
    try {
      startResponse = await _rawRequest(startUrl, 'POST', testStartPayload);
    } catch (e) {
      results.add(
        ApiEndpointStatus(
          name: 'Test Start',
          url: startUrl,
          method: 'POST',
          isRunning: false,
          statusCode: 0,
          message: shorten(e.toString()),
        ),
      );
      results.addAll(_skippedTestFlowRemainder('Skipped — /test/start failed'));
      return results;
    }
    results.add(
      _statusFromResponse('Test Start', startUrl, 'POST', startResponse),
    );

    if (startResponse.statusCode < 200 || startResponse.statusCode >= 300) {
      results.addAll(
        _skippedTestFlowRemainder('Skipped — /test/start did not return 200'),
      );
      return results;
    }

    String? sessionId;
    try {
      sessionId =
          (jsonDecode(startResponse.body) as Map)['session_id'] as String?;
    } catch (_) {
      // leave sessionId null, handled below
    }

    if (sessionId == null) {
      results.addAll(
        _skippedTestFlowRemainder(
          'Skipped — /test/start had no session_id in its response',
        ),
      );
      return results;
    }

    // Step 2: /test/next-question
    final nextUrl = '$liveBaseUrl/test/next-question';
    http.Response nextResponse;
    try {
      nextResponse = await _rawRequest(nextUrl, 'POST', {
        'session_id': sessionId,
      });
    } catch (e) {
      results.add(
        ApiEndpointStatus(
          name: 'Test Next Question',
          url: nextUrl,
          method: 'POST',
          isRunning: false,
          statusCode: 0,
          message: shorten(e.toString()),
        ),
      );
      results.add(
        ApiEndpointStatus(
          name: 'Test Submit Answer',
          url: '$liveBaseUrl/test/submit-answer',
          method: 'POST',
          isRunning: false,
          statusCode: 0,
          message: 'Skipped — /test/next-question failed',
        ),
      );
      results.add(
        await pingEndpoint(
          'Test Result',
          '$liveBaseUrl/test/result/$sessionId',
          'GET',
        ),
      );
      return results;
    }
    results.add(
      _statusFromResponse('Test Next Question', nextUrl, 'POST', nextResponse),
    );

    // Step 3: /test/submit-answer — build an answer that matches whatever
    // question_type came back (MCQ / Theory / Coding).
    final submitPayload = <String, dynamic>{'session_id': sessionId};
    if (nextResponse.statusCode >= 200 && nextResponse.statusCode < 300) {
      try {
        final questionData = jsonDecode(nextResponse.body) as Map;
        final qType = (questionData['question_type'] ?? '').toString();
        if (qType == 'MCQ') {
          final options = questionData['options'] as Map?;
          final firstKey = (options != null && options.isNotEmpty)
              ? options.keys.first.toString()
              : 'A';
          submitPayload['selected_option'] = firstKey;
        } else if (qType == 'Theory') {
          submitPayload['candidate_answer'] =
              'Diagnostic check answer — automated ping.';
        } else if (qType == 'Coding') {
          submitPayload['source_code'] = 'print("diagnostic")';
          submitPayload['language'] = 'python';
        } else {
          submitPayload['selected_option'] = 'A';
        }
      } catch (_) {
        submitPayload['selected_option'] = 'A';
      }
    } else {
      submitPayload['selected_option'] = 'A';
    }

    final submitUrl = '$liveBaseUrl/test/submit-answer';
    try {
      final submitResponse = await _rawRequest(
        submitUrl,
        'POST',
        submitPayload,
      );
      results.add(
        _statusFromResponse(
          'Test Submit Answer',
          submitUrl,
          'POST',
          submitResponse,
        ),
      );
    } catch (e) {
      results.add(
        ApiEndpointStatus(
          name: 'Test Submit Answer',
          url: submitUrl,
          method: 'POST',
          isRunning: false,
          statusCode: 0,
          message: shorten(e.toString()),
        ),
      );
    }

    // Step 4: /test/result/{session_id} — always check this, regardless of
    // how submit-answer went, since the session exists either way.
    results.add(
      await pingEndpoint(
        'Test Result',
        '$liveBaseUrl/test/result/$sessionId',
        'GET',
      ),
    );

    return results;
  }

  static Future<List<ApiEndpointStatus>> checkAllEndpoints() async {
    final independentResults = await Future.wait([
      pingEndpoint('Health Check', '$liveBaseUrl/health', 'GET'),
      pingEndpoint(
        'Generate Question',
        '$liveBaseUrl/generate-question',
        'POST',
        generateQuestionPayload,
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

    final testFlowResults = await _checkTestFlow();

    return [...independentResults, ...testFlowResults];
  }
}
