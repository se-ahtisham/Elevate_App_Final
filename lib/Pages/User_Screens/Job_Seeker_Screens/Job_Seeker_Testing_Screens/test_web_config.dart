// Placeholder config for the web-based test flow.
class TestWebConfig {
  static const String baseUrl = "https://elevate-saa-s.vercel.app";

  static Uri buildTestUrl(String testID) {
    return Uri.parse("$baseUrl/test/$testID");
  }
}
