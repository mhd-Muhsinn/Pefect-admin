import 'package:cloud_firestore/cloud_firestore.dart';

class DailyInsightModel {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final String? youtubeUrl;
  final String? externalLink;
  final Map<String, dynamic>? pdf; // {url, publicId, name}
  final Map<String, dynamic>? audioNote; // {url, publicId}

  final String createdBy;
  final DateTime createdAt;

  DailyInsightModel( {
    required this.createdAt,
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    this.youtubeUrl,
    this.externalLink,
    this.pdf,
    this.audioNote,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'youtubeUrl': youtubeUrl,
      'externalLink': externalLink,
      'pdf': pdf,
      'audioNote': audioNote,
      'createdBy': createdBy,
      'createdAt': DateTime.now(),
    };
  }

  factory DailyInsightModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DailyInsightModel(
      id: doc.id,
      courseId: doc.reference.parent.id,
      title: data['title'],
      description: data['description'],
      youtubeUrl: data['youtubeUrl'],
      externalLink: data['externalLink'],
      pdf: data['pdf'],
      audioNote: data['audioNote'],
      createdBy: data['createdBy'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
