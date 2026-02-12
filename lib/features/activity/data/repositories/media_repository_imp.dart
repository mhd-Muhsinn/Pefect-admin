import 'dart:io';
import '../../../../core/models/uploaded_media.dart';
import '../../../manage/data/services/media/cloudinary_service.dart';
import '../../domain/repositories/media_repository.dart';
import '../../../../core/enums/media_type.dart';


class MediaRepositoryImpl implements MediaRepository {
  final CloudinaryService cloudinaryService;

  MediaRepositoryImpl(this.cloudinaryService);

  @override
  Future<UploadedMedia> uploadMedia({
    required File file,
    required MediaType type,
    String? name,
  }) async {
    final result = await cloudinaryService.uploadFile(
      file,
      isVideo: type == MediaType.audio,
    );

    if (result == null) {
      throw Exception('Upload failed');
    }

    return UploadedMedia(
      url: result['secure_url'],
      publicId: result['public_id'],
      name: name,
      type: type,
    );
  }

  /// 🔴 DELETE IMPLEMENTATION
  @override
  Future<void> deleteMedia({
    required String publicId,
    required MediaType type,
  }) async {
    await cloudinaryService.deleteFile(
      publicId,
      isVideo: type == MediaType.audio,
    );
  }
}
