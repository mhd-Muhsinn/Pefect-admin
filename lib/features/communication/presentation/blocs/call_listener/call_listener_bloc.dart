import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/call_repository.dart';
import 'call_listener_event.dart';
import 'call_listener_state.dart';

class CallListenerBloc extends Bloc<CallListenerEvent, CallListenerState> {
  final CallRepository repo;
  StreamSubscription? _sub;
  String? _lastCallId; //  Track last shown call to prevent duplicates

  CallListenerBloc({required this.repo}) : super(CallIdle()) {
    
    on<StartCallListening>((event, emit) {
      _sub?.cancel(); // Cancel any existing subscription
      
      _sub = repo.listenIncoming().listen(
        (calls) {
          if (calls.isNotEmpty) {
            final incomingCall = calls.first;
            
            //  Only emit if it's a new call (different ID)
            if (_lastCallId != incomingCall.id) {
              _lastCallId = incomingCall.id;
              add(IncomingCallReceived(incomingCall));
            }
          } else {
            // No incoming calls - reset
            _lastCallId = null;
            add(NoIncomingCalls());
          }
        },
        onError: (error) {
          add(CallListenerErrorOccurred(error.toString()));
        },
      );
    });

    on<IncomingCallReceived>((event, emit) {
      // Emit the incoming call state
      emit(IncomingCallState(event.call));
      
      // Auto-reset to idle after a short delay so next call can trigger
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!isClosed) {
          add(ResetToIdle());
        }
      });
    });

    // NEW: Reset to idle event handler
    on<ResetToIdle>((event, emit) {
      // Only reset if we're still showing the same call
      if (state is IncomingCallState) {
        emit(CallIdle());
      }
    });

    on<NoIncomingCalls>((event, emit) {
      emit(CallIdle());
    });

    on<CallListenerErrorOccurred>((event, emit) {
      emit(CallListenerError(event.message));
    });

    on<StopCallListening>((event, emit) {
      _sub?.cancel();
      _sub = null;
      _lastCallId = null;
      emit(CallIdle());
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}