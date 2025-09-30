import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perfect_super_admin/features/manage/data/services/media/cloudinary_service.dart';
import 'dart:io';
import '../../../data/services/firebase_course_service.dart';
part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CloudinaryService cloudinaryService;
  final FirebaseCourseService firebaseService;

  CourseBloc({required this.cloudinaryService, required this.firebaseService})
      : super(CourseInitial()) {
    on<CreateCourseEvent>(_onCreateCourse);
    on<EditCourseEvent>(_onEditCourse);
    on<CourseVideoRemove>(_onCourseVideoDelete);
  }
  Future<void> _onEditCourse(
      EditCourseEvent event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    try {
      String? thumbnailUrl;
      String? thumbnailid;


      if (event.newThumbnail != null && event.oldThumbnailPublicId != null) {
        final newThumbData = await cloudinaryService.updateFile(
          newFile: event.newThumbnail!,
          oldPublicId: event.oldThumbnailPublicId!,
          isVideo: false,
        );

        if (newThumbData == null) {
          throw Exception("Failed to update thumbnail");
        }

        thumbnailUrl = newThumbData['secure_url'];
        thumbnailid = newThumbData['public_id'];
      }

      List<Map<String, dynamic>> updatedVideos = [];

      for (var video in event.videos) {
        final videoMap = {
          'title': video['title'],
          'description': video['description'],
          'video_url': video['video_url'],
          'public_id': video['public_id'],
          'videoDocId': video['videoDocId']
        };

        // NEW VIDEO (upload)
        if (video['isNew'] == true && video['file'] != null) {
          final uploaded = await cloudinaryService.uploadFile(
            video['file'],
            isVideo: true,
          );
          if (uploaded != null) {
            videoMap.addAll({
              'video_url': uploaded['secure_url'],
              'public_id': uploaded['public_id'],
              'format': uploaded['format'],
              'duration': uploaded['duration'],
              'created_at': uploaded['created_at'],
            });
          }
        }
        // UPDATED VIDEO
        else if (video['isUpdated'] == true) {
          if (video['file'] != null) {
            // Update video file
            final updatedVideo = await cloudinaryService.updateFile(
              newFile: video['file'],
              oldPublicId: video['public_id'],
              isVideo: true,
            );
            if (updatedVideo != null) {
              videoMap.addAll({
                'video_url': updatedVideo['secure_url'],
                'public_id': updatedVideo['public_id'],
                'format': updatedVideo['format'],
                'duration': updatedVideo['duration'],
                'created_at': updatedVideo['created_at'],
              });
            }
          }
        }

         updatedVideos.add(videoMap);
      }

      await firebaseService.updateCourse(
          courseId: event.courseId,
          name: event.name,
          description: event.description,
          price: event.price,
          thumbnailUrl: thumbnailUrl,
          videos: updatedVideos,
          thumbnailId: thumbnailid);

      emit(CourseSuccess());
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _onCreateCourse(
      CreateCourseEvent event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    try {
      final thumbnailData =
          await cloudinaryService.uploadFile(event.thumbnail, isVideo: false);
      final thumbnailUrl = thumbnailData?['secure_url'];

      if (thumbnailData == null) throw Exception("Thumbnail upload failed");

      List<Map<String, dynamic>> videoList = [];

      for (var v in event.videos) {
        final videoData =
            await cloudinaryService.uploadFile(v['file'], isVideo: true);

        if (videoData != null) {
          videoList.add({
            'title': v['title'],
            'description': v['description'],
            'video_url': videoData['secure_url'],
            'public_id': videoData['public_id'],
            'format': videoData['format'],
            'duration': videoData['duration'],
            'created_at': videoData['created_at'],
          });
        }
      }

      await firebaseService.createCourse(
          name: event.name,
          description: event.description,
          price: event.price,
          thumbnailUrl: thumbnailUrl,
          category: event.category,
          subcategory: event.subCategory,
          subSubCategory: event.subSubCategory,
          language: event.language,
          courseType: event.coursetype,
          videos: videoList,
          thumbnailId: thumbnailData['public_id'] ?? '');

      emit(CourseSuccess());
      
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _onCourseVideoDelete(
      CourseVideoRemove event, Emitter<CourseState> emit) async {
    emit(CourseVideoRemoving());
    try {
      await cloudinaryService.deleteFile(event.videoPublicId,isVideo: true);
      await firebaseService.deletecourseVideo(
          event.courseVideoId, event.courseId);
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }
}
