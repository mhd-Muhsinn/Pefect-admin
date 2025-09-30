import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CourseThumbnailCubit extends Cubit<File?> {
  CourseThumbnailCubit() : super(null);

  Future<void> pickThumbnail() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      emit(File(picked.path));
    }
  }

  void clearThumbnail() => emit(null);
}