import '../../../data/models/call_model.dart';

abstract class CallListenerEvent {}


class StartCallListening extends CallListenerEvent {}

class StopCallListening extends CallListenerEvent {}

class IncomingCallReceived extends CallListenerEvent {
  final CallModel call;
  
  IncomingCallReceived(this.call);
}

class NoIncomingCalls extends CallListenerEvent {}

class ResetToIdle extends CallListenerEvent {} // ✅ NEW EVENT

class CallListenerErrorOccurred extends CallListenerEvent {
  final String message;
  
  CallListenerErrorOccurred(this.message);
}