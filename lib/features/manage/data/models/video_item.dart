import 'dart:io';

class VideoItem {
  final String title;
  final String description;
  final File file; // For local use during upload
  final String? url; // For uploaded video URL
  final String? publicId;
  final String? docId;

  VideoItem({
    required this.title,
    required this.description,
    required this.file,
    this.url,
    this.publicId,
    this.docId,
  });
}
