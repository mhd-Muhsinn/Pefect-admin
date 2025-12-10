// lib/features/manage/presentation/cubits/tutor_request_state.dart
import 'package:equatable/equatable.dart';

class TutorRequestState extends Equatable {
  final List<Map<String, dynamic>> requests;
  final bool loading;
  final String? error;

  const TutorRequestState({
    this.requests = const [],
    this.loading = false,
    this.error,
  });

  TutorRequestState copyWith({
    List<Map<String, dynamic>>? requests,
    bool? loading,
    String? error,
  }) {
    return TutorRequestState(
      requests: requests ?? this.requests,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [requests, loading, error];
}
