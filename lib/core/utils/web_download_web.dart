import 'dart:convert';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Web implementation for CSV download using package:web (replaces dart:html)
void downloadCsvWeb(String csvContent, String filename) {
  final bytes = utf8.encode(csvContent);

  // Create a Blob from the bytes
  final jsArray = bytes.toJS;
  final blobParts = [jsArray].toJS;
  final blob = web.Blob(blobParts, web.BlobPropertyBag(type: 'text/csv'));

  // Create object URL for the blob
  final url = web.URL.createObjectURL(blob);

  // Create and click anchor element to download
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = filename;

  web.document.body?.append(anchor);
  anchor.click();
  anchor.remove();

  // Clean up the object URL
  web.URL.revokeObjectURL(url);
}
