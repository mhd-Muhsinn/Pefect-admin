part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

// Loading events...
class LoadUsersEvent extends ChatEvent {}
class LoadTrainersEvent extends ChatEvent {}


