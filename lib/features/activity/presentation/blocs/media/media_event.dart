import 'dart:io';

import '../../../../../core/enums/media_type.dart';

abstract class MediaEvent {}

class UploadMediaEvent extends MediaEvent {
  final File file;
  final MediaType type;
  final String? name;

  UploadMediaEvent({
    required this.file,
    required this.type,
    this.name,
  });


}
class DeleteMediaEvent extends MediaEvent {
  final String publicId;
  final MediaType type;

  DeleteMediaEvent({
    required this.publicId,
    required this.type,
  });
}
