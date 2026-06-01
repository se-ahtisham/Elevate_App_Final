import 'package:elevate_app/Data_Model_Classes/api_job_model.dart';

import 'text_normalizer.dart';

class JobRanker {
  static List<ApiJobModel> rank(List<ApiJobModel> jobs, String query) {
    final q = TextNormalizer.normalize(query);

    int score(ApiJobModel job) {
      int s = 0;

      final title = TextNormalizer.normalize(job.title);
      final company = TextNormalizer.normalize(job.company);

      if (title.contains(q)) s += 5;
      if (company.contains(q)) s += 2;

      if (job.isRemote) s += 2;

      if (job.postedAt != null) {
        final hours = DateTime.now().difference(job.postedAt!).inHours;
        if (hours < 24)
          s += 3;
        else if (hours < 72)
          s += 1;
      }

      return s;
    }

    jobs.sort((a, b) => score(b).compareTo(score(a)));
    return jobs;
  }
}
