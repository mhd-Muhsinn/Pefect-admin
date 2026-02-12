part of 'chat_message_bloc.dart';

@immutable
sealed class ChatMessageState extends Equatable {}

class ChatMessageInitial extends ChatMessageState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MessagesLoading extends ChatMessageState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MessagesLoaded extends ChatMessageState {
  final List<Map<String, dynamic>> messages;
  MessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class MessagesError extends ChatMessageState {
  final String error;
  MessagesError(this.error);

  @override
  List<Object?> get props => [error];
}
