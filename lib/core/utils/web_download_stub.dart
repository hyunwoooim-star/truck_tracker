/// Stub implementation for non-web platforms
void downloadCsvWeb(String csvContent, String filename) {
  // No-op on non-web platforms
  // On mobile/desktop, you would use a different approach (file_saver, path_provider, etc.)
  throw UnsupportedError('CSV download is only supported on web platform');
}
