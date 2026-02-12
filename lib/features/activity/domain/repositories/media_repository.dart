import '../../../../core/enums/media_type.dart';
import 'dart:io';

import '../../../../core/models/uploaded_media.dart';

abstract class MediaRepository {
  Future<UploadedMedia> uploadMedia({
    required File file,
    required MediaType type,
    String? name,
  });


  Future<void> deleteMedia({
    required String publicId,
    required MediaType type,
  });
}
