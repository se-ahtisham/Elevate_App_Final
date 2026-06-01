import 'dart:convert';
import 'package:elevate_app/Data_Model_Classes/api_job_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../utils/job_cleaner.dart';
import '../utils/job_ranker.dart';

class JobService {
  static String _apiKey = dotenv.env['Job_Ai_API_KEY'] ?? '';

  static const String _arbeitnowUrl =
      'https://www.arbeitnow.com/api/job-board-api';
  static const Duration _timeout = Duration(seconds: 15);

  Future<List<ApiJobModel>> fetchAllJobs(String query) async {
    final results = await Future.wait([
      _fetchJSearch(query).catchError((_) => <ApiJobModel>[]),
      _fetchArbeitnow().catchError((_) => <ApiJobModel>[]),
    ]);

    List<ApiJobModel> jobs = [...results[0], ...results[1]];

    if (jobs.isEmpty) {
      throw Exception('No jobs fetched from any source');
    }

    jobs = JobCleaner.clean(jobs);
    jobs = JobRanker.rank(jobs, query);

    return jobs;
  }

  Future<List<ApiJobModel>> _fetchJSearch(String query) async {
    final uri = Uri.https('jsearch.p.rapidapi.com', '/search', {
      'query': query,
      'page': '1',
      'num_pages': '1',
    });

    final res = await http
        .get(
          uri,
          headers: {
            'x-rapidapi-key': _apiKey,
            'x-rapidapi-host': 'jsearch.p.rapidapi.com',
          },
        )
        .timeout(_timeout); // FIX: timeout so it doesn't hang forever

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final data = body['data'];
      if (data is List) {
        return data.map((e) => ApiJobModel.fromJSearch(e)).toList();
      }
    }

    return [];
  }

  Future<List<ApiJobModel>> _fetchArbeitnow() async {
    final res = await http
        .get(Uri.parse(_arbeitnowUrl))
        .timeout(_timeout); // FIX: timeout

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final data = body['data'];
      if (data is List) {
        return data.map((e) => ApiJobModel.fromArbeitnow(e)).toList();
      }
    }

    return [];
  }
}
