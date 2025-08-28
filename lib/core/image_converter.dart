abstract class ImageConverter {
  static String convertDriveLinkToDirect(String originalUrl) {
    // Regex to extract the file ID from Google Drive URL
    final RegExp regExp = RegExp(r'd/([^/]+)');
    final match = regExp.firstMatch(originalUrl);

    if (match != null && match.groupCount >= 1) {
      final fileId = match.group(1);
      return 'https://drive.google.com/uc?export=view&id=$fileId';
    } else {
      return originalUrl; // fallback if not matched
    }
  }
}
