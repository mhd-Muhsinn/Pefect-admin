part of 'chat_message_bloc.dart';

@immutable
sealed class ChatMessageEvent extends Equatable{}


// Load chat messages between two users
class LoadMessagesEvent extends ChatMessageEvent {
  final String otherUserId;

   LoadMessagesEvent(this.otherUserId);

  @override
  List<Object?> get props => [otherUserId];
}

// Send a message
class SendMessageEvent extends ChatMessageEvent {
  final String receiverId;
  final String message;

   SendMessageEvent(this.receiverId, this.message);

  @override
  List<Object?> get props => [receiverId, message];
}