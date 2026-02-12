import 'package:bloc/bloc.dart';
import 'package:perfect_super_admin/features/manage/data/services/media/cloudinary_service.dart';

import '../../../domain/usecases/delete_media.dart';
import '../../../domain/usecases/upload_media.dart';
import 'media_event.dart';
import 'media_state.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final UploadMedia uploadMedia;
  final DeleteMedia deleteMedia;

  MediaBloc({required this.deleteMedia,required this.uploadMedia}) : super(MediaInitial()) {
    on<UploadMediaEvent>(_onUpload);
      on<DeleteMediaEvent>(_onDeleteMedia); 
  }

  Future<void> _onUpload(
    UploadMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(MediaUploading());
    try {
      final media = await uploadMedia(
        file: event.file,
        type: event.type,
        name: event.name,
      );
      emit(MediaUploadSuccess(media));
    } catch (e) {
      emit(MediaUploadFailure(e.toString()));
    }
  }
     Future<void> _onDeleteMedia(
    DeleteMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(MediaDeleting());

    try {
      await deleteMedia(
        publicId: event.publicId,
        type: event.type,
      );

      emit(MediaDeleteSuccess());
    } catch (e) {
      emit(MediaDeleteFailure(e.toString()));
    }
  }
}

