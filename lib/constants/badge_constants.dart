class BadgeConstants {
  static const String bronzeUrl =
      'https://firebasestorage.googleapis.com/v0/b/elevate-988ab.firebasestorage.app/o/badge_images%2Fbronze.png?alt=media&token=116cd0ca-d646-430a-8246-dfff9d29b673';
  static const String goldUrl =
      'https://firebasestorage.googleapis.com/v0/b/elevate-988ab.firebasestorage.app/o/badge_images%2Fgold.png?alt=media&token=8fa4f2b5-07f5-4b84-a943-02abb5989d72';
  static const String silverUrl =
      'https://firebasestorage.googleapis.com/v0/b/elevate-988ab.firebasestorage.app/o/badge_images%2Fsilver.png?alt=media&token=8ace9945-0206-4491-b175-db75e70b9ff7';

  static String getBadgeUrl(String name) {
    final lower = name.toLowerCase().trim();
    if (lower.contains('gold')) {
      return goldUrl;
    } else if (lower.contains('silver')) {
      return silverUrl;
    } else {
      return bronzeUrl;
    }
  }
}
