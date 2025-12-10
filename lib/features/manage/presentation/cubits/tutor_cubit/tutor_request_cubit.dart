import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/features/manage/data/repositories/tutors_repository.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/features/manage/presentation/cubits/tutor_cubit/tutor_request_state.dart';

class TutorRequestCubit extends Cubit<TutorRequestState> {
  final TutorRequestRepository repository = TutorRequestRepository();
  StreamSubscription? _sub;

  TutorRequestCubit() : super(const TutorRequestState());

  void startListening() {
    emit(state.copyWith(loading: true));
    _sub = repository.getPendingRequests().listen(
      (requests) {
        emit(state.copyWith(requests: requests, loading: false, error: null));
      },
      onError: (err) {
        emit(state.copyWith(error: err.toString(), loading: false));
      },
    );
  }

  Future<void> acceptRequest(String docId) async {
    await repository.acceptRequest(docId);
  }

  Future<void> rejectRequest(String docId) async {
    await repository.rejectRequest(docId);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}

