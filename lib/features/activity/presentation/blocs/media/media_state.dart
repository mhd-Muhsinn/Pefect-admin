import '../../../../../core/models/uploaded_media.dart';

abstract class MediaState {}

class MediaInitial extends MediaState {}

class MediaUploading extends MediaState {}

class MediaUploadSuccess extends MediaState {
  final UploadedMedia media;
  MediaUploadSuccess(this.media);
}

class MediaUploadFailure extends MediaState {
  final String message;
  MediaUploadFailure(this.message);
}

class MediaDeleting extends MediaState {}

class MediaDeleteSuccess extends MediaState {}

class MediaDeleteFailure extends MediaState {
  final String message;

  MediaDeleteFailure(this.message);
}
