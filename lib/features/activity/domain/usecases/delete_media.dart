import '../repositories/media_repository.dart';
import '../../../../core/enums/media_type.dart';

class DeleteMedia {
  final MediaRepository repository;

  DeleteMedia(this.repository);

  Future<void> call({
    required String publicId,
    required MediaType type,
  }) {
    return repository.deleteMedia(
      publicId: publicId,
      type: type,
    );
  }
}
