// Placeholder config for the web-based test flow.
class TestWebConfig {
  static const String baseUrl = "https://elevate-app.example.com";

  static Uri buildTestUrl(String testID) {
    return Uri.parse("$baseUrl/test/$testID");
  }
}
