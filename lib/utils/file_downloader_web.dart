// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Future<void> downloadFile(String url, String fileName) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final blob = html.Blob([response.bodyBytes]);
      final blobUrl = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: blobUrl)
        ..setAttribute("download", fileName.isNotEmpty ? fileName : "download_file.txt")
        ..style.display = 'none';
      html.document.body?.children.add(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(blobUrl);
      return;
    }
  } catch (_) {}

  // Fallback to external url_launcher if blob download fails
  final uri = Uri.parse(url);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
