import 'package:cloud_firestore/cloud_firestore.dart';

class CallModel {
  final String id;
  final String callerId;
  final String receiverId;
  final String callType; // 'audio' or 'video'
  final String? callerName;
  final String status; // 'ringing', 'accepted', 'rejected', 'ended'
  final DateTime? createdAt;
  final DateTime? acceptedAt;
  final DateTime? rejectedAt;
  final DateTime? endedAt;

  CallModel({
    required this.id,
    required this.callerId,
    required this.receiverId,
    required this.callType,
    this.callerName,
    required this.status,
    this.createdAt,
    this.acceptedAt,
    this.rejectedAt,
    this.endedAt,
  });

  factory CallModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return CallModel(
      id: doc.id,
      callerId: data['callerId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      callType: data['callType'] ?? 'audio',
      callerName: data['callerName'],
      status: data['status'] ?? 'ringing',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      acceptedAt: (data['acceptedAt'] as Timestamp?)?.toDate(),
      rejectedAt: (data['rejectedAt'] as Timestamp?)?.toDate(),
      endedAt: (data['endedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'callerId': callerId,
      'receiverId': receiverId,
      'callType': callType,
      'callerName': callerName,
      'status': status,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'acceptedAt': acceptedAt != null ? Timestamp.fromDate(acceptedAt!) : null,
      'rejectedAt': rejectedAt != null ? Timestamp.fromDate(rejectedAt!) : null,
      'endedAt': endedAt != null ? Timestamp.fromDate(endedAt!) : null,
    };
  }

  CallModel copyWith({
    String? id,
    String? callerId,
    String? receiverId,
    String? callType,
    String? callerName,
    String? status,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? rejectedAt,
    DateTime? endedAt,
  }) {
    return CallModel(
      id: id ?? this.id,
      callerId: callerId ?? this.callerId,
      receiverId: receiverId ?? this.receiverId,
      callType: callType ?? this.callType,
      callerName: callerName ?? this.callerName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      endedAt: endedAt ?? this.endedAt,
    );
  }
}