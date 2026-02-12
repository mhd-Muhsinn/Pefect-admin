import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:perfect_super_admin/features/communication/data/services/chat/chat_service.dart';
part 'chat_message_event.dart';
part 'chat_message_state.dart';

class ChatMessageBloc extends Bloc<ChatMessageEvent, ChatMessageState> {
  ChatService chatService = ChatService();
  ChatMessageBloc() : super(ChatMessageInitial()) {
    on<LoadMessagesEvent>((event, emit) async {
      emit(MessagesLoading());
      await emit.forEach<QuerySnapshot>(
        chatService.getMessages(event.otherUserId),
        onData: (snapshot) {
          final messages = snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();

          return MessagesLoaded(messages);
        },
        onError: (err, _) => MessagesError(err.toString()),
      );
    });

    on<SendMessageEvent>((event, emit) async {
      try {
        await chatService.sendMessage(event.receiverId, event.message);
      } catch (err) {
        emit(MessagesError(err.toString()));
      }
    });
  }
}
