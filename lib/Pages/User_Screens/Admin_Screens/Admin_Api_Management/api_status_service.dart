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
  final String group;

  ApiEndpointStatus({
    required this.name,
    required this.url,
    required this.method,
    required this.isRunning,
    required this.statusCode,
    required this.group,
    this.message,
  });
}

class ApiStatusChecker {
  static const String engineBaseUrl =
      'https://elevate-backend-rtdg.onrender.com';
  static const String nlpBaseUrl = 'https://elevate-backend-nlp.onrender.com';

  static const String engineGroup = 'ELEVATE ENGINE (RENDER)';
  static const String nlpGroup = 'ELEVATE NLP ENGINE (RENDER)';

  static const Duration requestTimeout = Duration(seconds: 15);

  // ---------- Engine payloads ----------

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

  // ---------- NLP payloads ----------

  // NOTE: adjust field names below to match the exact request schema
  // shown on /docs for review-submit if this differs from your backend.
  static const Map<String, dynamic> reviewSubmitPayload = {
    'company_email': 'admin_test@elevate.com',
    'company_name': 'Elevate Diagnostics Co',
    'review_text':
        'This is an automated diagnostic review submitted by the admin API status checker.',
    'rating': 5,
  };

  static const String testCompanyEmail = 'admin_test@elevate.com';

  // ---------- Core request helpers ----------

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
    String group,
    http.Response response,
  ) {
    final ok = response.statusCode >= 200 && response.statusCode < 300;
    return ApiEndpointStatus(
      name: name,
      url: url,
      method: method,
      group: group,
      isRunning: ok,
      statusCode: response.statusCode,
      message: ok ? null : shorten(response.body),
    );
  }

  static Future<ApiEndpointStatus> pingEndpoint(
    String name,
    String url,
    String method,
    String group, [
    Map<String, dynamic>? body,
  ]) async {
    try {
      final response = await _rawRequest(url, method, body);
      return _statusFromResponse(name, url, method, group, response);
    } catch (e) {
      return ApiEndpointStatus(
        name: name,
        url: url,
        method: method,
        group: group,
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

  // ---------- Engine: chained test flow ----------

  static List<ApiEndpointStatus> _skippedTestFlowRemainder(String reason) {
    return [
      ApiEndpointStatus(
        name: 'Test Next Question',
        url: '$engineBaseUrl/test/next-question',
        method: 'POST',
        group: engineGroup,
        isRunning: false,
        statusCode: 0,
        message: reason,
      ),
      ApiEndpointStatus(
        name: 'Test Submit Answer',
        url: '$engineBaseUrl/test/submit-answer',
        method: 'POST',
        group: engineGroup,
        isRunning: false,
        statusCode: 0,
        message: reason,
      ),
      ApiEndpointStatus(
        name: 'Test Result',
        url: '$engineBaseUrl/test/result/{session_id}',
        method: 'GET',
        group: engineGroup,
        isRunning: false,
        statusCode: 0,
        message: reason,
      ),
      ApiEndpointStatus(
        name: 'Test Recommendation',
        url: '$engineBaseUrl/test/recommendation/{session_id}',
        method: 'GET',
        group: engineGroup,
        isRunning: false,
        statusCode: 0,
        message: reason,
      ),
    ];
  }

  static Future<List<ApiEndpointStatus>> _checkTestFlow() async {
    final results = <ApiEndpointStatus>[];
    final startUrl = '$engineBaseUrl/test/start';

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
          group: engineGroup,
          isRunning: false,
          statusCode: 0,
          message: shorten(e.toString()),
        ),
      );
      results.addAll(_skippedTestFlowRemainder('Skipped — /test/start failed'));
      return results;
    }
    results.add(
      _statusFromResponse(
        'Test Start',
        startUrl,
        'POST',
        engineGroup,
        startResponse,
      ),
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
    final nextUrl = '$engineBaseUrl/test/next-question';
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
          group: engineGroup,
          isRunning: false,
          statusCode: 0,
          message: shorten(e.toString()),
        ),
      );
      results.add(
        ApiEndpointStatus(
          name: 'Test Submit Answer',
          url: '$engineBaseUrl/test/submit-answer',
          method: 'POST',
          group: engineGroup,
          isRunning: false,
          statusCode: 0,
          message: 'Skipped — /test/next-question failed',
        ),
      );
      results.add(
        await pingEndpoint(
          'Test Result',
          '$engineBaseUrl/test/result/$sessionId',
          'GET',
          engineGroup,
        ),
      );
      results.add(
        await pingEndpoint(
          'Test Recommendation',
          '$engineBaseUrl/test/recommendation/$sessionId',
          'GET',
          engineGroup,
        ),
      );
      return results;
    }
    results.add(
      _statusFromResponse(
        'Test Next Question',
        nextUrl,
        'POST',
        engineGroup,
        nextResponse,
      ),
    );

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

    final submitUrl = '$engineBaseUrl/test/submit-answer';
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
          engineGroup,
          submitResponse,
        ),
      );
    } catch (e) {
      results.add(
        ApiEndpointStatus(
          name: 'Test Submit Answer',
          url: submitUrl,
          method: 'POST',
          group: engineGroup,
          isRunning: false,
          statusCode: 0,
          message: shorten(e.toString()),
        ),
      );
    }

    results.add(
      await pingEndpoint(
        'Test Result',
        '$engineBaseUrl/test/result/$sessionId',
        'GET',
        engineGroup,
      ),
    );

    results.add(
      await pingEndpoint(
        'Test Recommendation',
        '$engineBaseUrl/test/recommendation/$sessionId',
        'GET',
        engineGroup,
      ),
    );

    return results;
  }

  // ---------- Public entry point ----------

  static Future<List<ApiEndpointStatus>> checkAllEndpoints() async {
    final engineIndependent = await Future.wait([
      pingEndpoint('Health Check', '$engineBaseUrl/health', 'GET', engineGroup),
      pingEndpoint(
        'Generate Question',
        '$engineBaseUrl/generate-question',
        'POST',
        engineGroup,
        generateQuestionPayload,
      ),
      pingEndpoint(
        'Record Answer',
        '$engineBaseUrl/record-answer',
        'POST',
        engineGroup,
        recordAnswerPayload,
      ),
      pingEndpoint(
        'Evaluate MCQ',
        '$engineBaseUrl/evaluate-mcq',
        'POST',
        engineGroup,
        evaluateMcqPayload,
      ),
      pingEndpoint(
        'Evaluate Theory',
        '$engineBaseUrl/evaluate-theory',
        'POST',
        engineGroup,
        evaluateTheoryPayload,
      ),
      pingEndpoint(
        'Evaluate Coding',
        '$engineBaseUrl/evaluate-coding',
        'POST',
        engineGroup,
        evaluateCodingPayload,
      ),
      pingEndpoint('AI Logs', '$engineBaseUrl/ai-logs', 'GET', engineGroup),
    ]);

    final engineTestFlow = await _checkTestFlow();

    final nlpResults = await Future.wait([
      pingEndpoint('Health Check', '$nlpBaseUrl/health', 'GET', nlpGroup),
      pingEndpoint(
        'Review Submit',
        '$nlpBaseUrl/review/submit',
        'POST',
        nlpGroup,
        reviewSubmitPayload,
      ),
      pingEndpoint(
        'Review Company Profile',
        '$nlpBaseUrl/review/company/$testCompanyEmail',
        'GET',
        nlpGroup,
      ),
    ]);

    return [...engineIndependent, ...engineTestFlow, ...nlpResults];
  }
}
