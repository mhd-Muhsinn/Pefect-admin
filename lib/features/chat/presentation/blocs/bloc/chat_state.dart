part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> trainers;
  final bool isUsersLoading;
  final bool isTrainersLoading;
  final String? error;

  const ChatState({
    this.users = const [],
    this.trainers = const [],
    this.isUsersLoading = false,
    this.isTrainersLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<Map<String, dynamic>>? users,
    List<Map<String, dynamic>>? trainers,
    bool? isUsersLoading,
    bool? isTrainersLoading,
    String? error,
  }) {
    return ChatState(
      users: users ?? this.users,
      trainers: trainers ?? this.trainers,
      isUsersLoading: isUsersLoading ?? this.isUsersLoading,
      isTrainersLoading: isTrainersLoading ?? this.isTrainersLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [users,trainers,isUsersLoading,isTrainersLoading,error];
}


class ChatInitial extends ChatState {}

class UsersLoading extends ChatState {}

class UsersLoaded extends ChatState {
  final List<Map<String, dynamic>> users;
  UsersLoaded(this.users);
  @override
  List<Object> get props => [users];
}

class UsersError extends ChatState {
  final String error;
  UsersError(this.error);
  @override
  List<Object> get props => [error];
}

class TrainersLoading extends ChatState {}

class TrainersLoaded extends ChatState {
  final List<Map<String, dynamic>> trainers;
  TrainersLoaded(this.trainers);
  @override
  List<Object> get props => [trainers];
}

class TrainersError extends ChatState {
  final String error;
  TrainersError(this.error);
  @override
  List<Object> get props => [error];
}
