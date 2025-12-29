import 'dart:convert';
import 'dart:html' as html;

/// Web implementation for CSV download
void downloadCsvWeb(String csvContent, String filename) {
  final bytes = utf8.encode(csvContent);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  (html.AnchorElement(href: url)
    ..setAttribute('download', filename))
    .click();
  html.Url.revokeObjectUrl(url);
}
