import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/course_video_cubit.dart';

class Course {
  final String id;
  final String name;
  final String description;
  final String price;
  final String thumbnailUrl;
  final String thumbnailId;
  final Timestamp createdAt;
  final List<VideoItem> videos;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.thumbnailUrl,
    required this.thumbnailId,
    required this.createdAt,
    required this.videos,
  });
}
