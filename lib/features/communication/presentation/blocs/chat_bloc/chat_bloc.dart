import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';
import 'package:perfect_super_admin/features/communication/data/models/message.dart';
import 'package:perfect_super_admin/features/communication/data/services/chat/chat_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService chatService = ChatService();

  ChatBloc() : super(const ChatState()) {
    on<LoadUsersEvent>((event, emit) async {
      emit(state.copyWith(isUsersLoading: true));
      await emit.forEach<List<Map<String, dynamic>>>(
        chatService.getUserStream(),
        onData: (users) => state.copyWith(users: users, isUsersLoading: false),
        onError: (err, _) =>
            state.copyWith(error: err.toString(), isUsersLoading: false),
      );
    });

    on<LoadTrainersEvent>((event, emit) async {
      emit(state.copyWith(isTrainersLoading: true));
      await emit.forEach<List<Map<String, dynamic>>>(
        chatService.getTrainersStream(),
        onData: (trainers) =>
            state.copyWith(trainers: trainers, isTrainersLoading: false),
        onError: (err, _) =>
            state.copyWith(error: err.toString(), isTrainersLoading: false),
      );
    });

  }
}
