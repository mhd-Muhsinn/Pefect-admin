import '../enums/media_type.dart';

class UploadedMedia {
  final String url;
  final String publicId;
  final String? name;
  final MediaType type;

  UploadedMedia({
    required this.url,
    required this.publicId,
    required this.type,
    this.name,
  });
}


