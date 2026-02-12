import 'dart:io';

import '../../../../core/enums/media_type.dart';
import '../../../../core/models/uploaded_media.dart';
import '../../../manage/data/services/media/cloudinary_service.dart';

class UploadMedia {
  final CloudinaryService cloudinary;

  UploadMedia(this.cloudinary);

  Future<UploadedMedia> call({
    required File file,
    required MediaType type,
    String? name,
  }) async {
    final res = await cloudinary.uploadByType(
      file: file,
      resourceType: type.resourceType,
      folder: type.folder,
    );

    if (res == null) {
      throw Exception('Media upload failed');
    }

    return UploadedMedia(
      url: res['secure_url'],
      publicId: res['public_id'],
      name: name,
      type: type,
    );
  }
}
