import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class VideoItem {
  final String title;
  final String description;
  final File? file;
  final String? videoUrl;
  final String? publicId;
  final bool isUpdated; // true if edited or file changed
  final bool isNew; // true if newly added
  final String? documentId;

  VideoItem({
    required this.title,
    required this.description,
    this.file,
    this.videoUrl,
    this.publicId,
    this.documentId,
    this.isUpdated = false,
    this.isNew = false,
  });

  factory VideoItem.fromMap(Map<String, dynamic> map) {
    return VideoItem(
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        videoUrl: map['video_url'],
        publicId: map['public_id'],
        isNew: false,
        isUpdated: false,
        documentId: map['videoDocId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'file': file,
      'video_url': videoUrl,
      'public_id': publicId,
      'isUpdated': isUpdated,
      'isNew': isNew,
      'videoDocId': documentId
    };
  }
}

class CourseVideosCubit extends Cubit<List<VideoItem>> {
  CourseVideosCubit() : super([]);

  void initializeWith(List<VideoItem> videos) {
    emit(List<VideoItem>.from(videos));
  }

  void addVideo({
    required String title,
    required String description,
    required File file,
  }) {
    final video = VideoItem(
      title: title,
      description: description,
      file: file,
      isNew: true,
    );
    emit([...state, video]);
  }

  void removeVideo(int index) {
    final updated = [...state]..removeAt(index);
    emit(updated);
  }

  void updateVideo(int index, VideoItem updatedItem) {
    final updatedList = [...state];
    final oldItem = updatedList[index];

    updatedList[index] = VideoItem(
      title: updatedItem.title,
      description: updatedItem.description,
      file: updatedItem.file ?? oldItem.file,
      videoUrl: oldItem.videoUrl,
      publicId: oldItem.publicId,
      documentId: oldItem.documentId,
      isUpdated: updatedItem.file != null ||
          updatedItem.title != oldItem.title ||
          updatedItem.description != oldItem.description,
      isNew: oldItem.isNew,
    );
    emit(updatedList);
  }

  void clearAll() => emit([]);
  void markAllAsSynced() {
    final updated = state.map((video) {
      return VideoItem(
        title: video.title,
        description: video.description,
        file: video.file,
        videoUrl: video.videoUrl,
        publicId: video.publicId,
        isNew: false,
        isUpdated: false,
      );
    }).toList();

    emit(updated);
  }
}
