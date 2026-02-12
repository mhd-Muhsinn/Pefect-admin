import '../../../data/models/call_model.dart';

abstract class CallActionState {}

class CallActionInitial extends CallActionState {}

class CallActionLoading extends CallActionState {}

class CallStarted extends CallActionState {
  final CallModel call; // Return full call model instead of just ID
  
  CallStarted({required this.call});
}

class CallAccepted extends CallActionState {
  final CallModel call;
  
  CallAccepted(this.call);
}

class CallRejected extends CallActionState {}

class CallEnded extends CallActionState {}

class CallActionError extends CallActionState {
  final String message;
  
  CallActionError(this.message);
}