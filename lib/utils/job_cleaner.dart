import 'package:elevate_app/Data_Model_Classes/api_job_model.dart';
import 'text_normalizer.dart';

class JobCleaner {
  static List<ApiJobModel> clean(List<ApiJobModel> jobs) {
    final Map<String, ApiJobModel> unique = {};

    for (final job in jobs) {
      if (job.title.isEmpty || job.company.isEmpty || job.applyUrl.isEmpty) {
        continue;
      }

      final key =
          '${TextNormalizer.normalize(job.title)}@${TextNormalizer.normalize(job.company)}';

      unique.putIfAbsent(key, () => job);
    }

    return unique.values.toList();
  }
}
