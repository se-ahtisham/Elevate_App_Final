// lib/services/api_status_service.dart

import 'package:http/http.dart' as http;

class ApiEndpointStatus {
  final String name;
  final String url;
  final bool isRunning;
  final int statusCode;
  final String? message;

  ApiEndpointStatus({
    required this.name,
    required this.url,
    required this.isRunning,
    required this.statusCode,
    this.message,
  });
}

class ApiStatusChecker {
  static const String engineBaseUrl =
      'https://elevate-backend-rtdg.onrender.com';
  static const String nlpBaseUrl = 'https://elevate-backend-nlp.onrender.com';

  static const Duration requestTimeout = Duration(seconds: 15);

  static Future<ApiEndpointStatus> _checkHealth(
    String name,
    String baseUrl,
  ) async {
    final url = '$baseUrl/health';
    try {
      final response = await http.get(Uri.parse(url)).timeout(requestTimeout);
      final ok = response.statusCode >= 200 && response.statusCode < 300;
      return ApiEndpointStatus(
        name: name,
        url: url,
        isRunning: ok,
        statusCode: response.statusCode,
        message: ok ? null : shorten(response.body),
      );
    } catch (e) {
      return ApiEndpointStatus(
        name: name,
        url: url,
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

  static Future<List<ApiEndpointStatus>> checkAllEndpoints() async {
    return Future.wait([
      _checkHealth('Elevate Engine', engineBaseUrl),
      _checkHealth('Elevate NLP Engine', nlpBaseUrl),
    ]);
  }
}
