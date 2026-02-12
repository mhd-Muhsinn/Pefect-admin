enum MediaType {
  pdf,
  audio,
}

extension MediaTypeX on MediaType {
  String get resourceType {
    switch (this) {
      case MediaType.pdf:
        return 'raw';
      case MediaType.audio:
        return 'video';
    }
  }

  String get folder {
    switch (this) {
      case MediaType.pdf:
        return 'daily_insights/pdf';
      case MediaType.audio:
        return 'daily_insights/audio';
    }
  }
}
