import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/call_model.dart';
import '../../../data/repositories/call_repository.dart';
import 'call_action_event.dart';
import 'call_action_state.dart';

class CallActionBloc extends Bloc<CallActionEvent, CallActionState> {
  final CallRepository repository;

  CallActionBloc(this.repository) : super(CallActionInitial()) {
    
    // Start outgoing call
    on<StartCallEvent>((event, emit) async {
      emit(CallActionLoading());
      try {
        final call = await repository.startCall(
          receiverId: event.receiverId,
          callType: event.callType,
          callerName: event.callerName,
        );
        // Return the full call model for navigation
        emit(CallStarted(call: call));
      } catch (e) {
        emit(CallActionError(e.toString()));
      }
    });

    // Accept incoming call
    on<AcceptCallEvent>((event, emit) async {
      emit(CallActionLoading());
      try {
        await repository.acceptCall(event.call);
        emit(CallAccepted(event.call));
      } catch (e) {
        emit(CallActionError(e.toString()));
      }
    });

    // Reject incoming call
    on<RejectCallEvent>((event, emit) async {
      emit(CallActionLoading());
      try {
        await repository.rejectCall(event.call.id);
        emit(CallRejected());
      } catch (e) {
        emit(CallActionError(e.toString()));
      }
    });

    // End active call
    on<EndCallEvent>((event, emit) async {
      emit(CallActionLoading());
      try {
        await repository.endCall(event.callId);
        emit(CallEnded());
      } catch (e) {
        emit(CallActionError(e.toString()));
      }
    });
  }
}