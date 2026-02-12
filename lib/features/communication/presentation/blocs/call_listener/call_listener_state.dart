import '../../../data/models/call_model.dart';

abstract class CallListenerState {}

class CallIdle extends CallListenerState {}

class IncomingCallState extends CallListenerState {
  final CallModel call;
  
  IncomingCallState(this.call);
}

class CallListenerError extends CallListenerState {
  final String message;
  
  CallListenerError(this.message);
}