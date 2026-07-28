// review_api_service.dart
//
// Talks to the Elevate-Backend-NLP service (elevate-backend-nlp.onrender.com).
// This REPLACES the old direct-to-Firestore write in
// FirebaseService.submitEmployeeReview() for the review-submit flow: the
// backend does sentiment (Groq) + aspect matching (Firestore keyword pool)
// and writes companies/{companyID}.companyStrengthList /
// companyWeaknessList itself, so CompanyProfile keeps working unchanged.
//
// Uses the `http` package, already in pubspec.yaml.

import 'dart:convert';
import 'package:http/http.dart' as http;

class ReviewApiException implements Exception {
  final String message;
  final int? statusCode;
  ReviewApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ReviewApiService {
  static const String _baseUrl = 'https://elevate-backend-nlp.onrender.com';

  /// Submits a raw review for AI sentiment + aspect analysis.
  /// Throws [ReviewApiException] with statusCode 409 if this job seeker has
  /// already reviewed this company (server-side duplicate guard).
  Future<Map<String, dynamic>> submitReview({
    required String companyID,
    required String companyName,
    required String companyEmail,
    required String jobSeekerID,
    required String rawReview,
  }) async {
    final uri = Uri.parse('$_baseUrl/review/submit');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'company_id': companyID,
        'company_name': companyName,
        'company_email': companyEmail,
        'job_seeker_id': jobSeekerID,
        'raw_review': rawReview,
      }),
    );

    final Map<String, dynamic> body = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : {};

    if (response.statusCode == 200) {
      return body;
    }

    final detail =
        body['detail']?.toString() ??
        'Something went wrong submitting your review.';
    throw ReviewApiException(detail, statusCode: response.statusCode);
  }

  /// Optional: fetch a company's current AI-derived strengths/weaknesses
  /// directly, instead of listening to the Firestore doc.
  Future<Map<String, dynamic>> getCompanyProfile(String companyID) async {
    final uri = Uri.parse('$_baseUrl/review/company/$companyID');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw ReviewApiException(
      'Could not load company AI profile.',
      statusCode: response.statusCode,
    );
  }
}
