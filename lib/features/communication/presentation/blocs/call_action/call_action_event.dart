import '../../../data/models/call_model.dart';

abstract class CallActionEvent {}

/// User initiates a call
class StartCallEvent extends CallActionEvent {
  final String receiverId;
  final String callType; // audio | video
  final String callerName; // Display name for Zego UI

  StartCallEvent({
    required this.receiverId,
    required this.callType,
    required this.callerName,
  });
}

/// Receiver accepts an incoming call
class AcceptCallEvent extends CallActionEvent {
  final CallModel call;

  AcceptCallEvent(this.call);
}

/// Receiver rejects an incoming call
class RejectCallEvent extends CallActionEvent {
  final CallModel call;

  RejectCallEvent(this.call);
}

/// Either side ends an ongoing call
class EndCallEvent extends CallActionEvent {
  final String callId;

  EndCallEvent(this.callId);
}