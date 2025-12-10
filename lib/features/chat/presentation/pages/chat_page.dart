import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/widgets/common/custom_appbar.dart';
import 'package:perfect_super_admin/features/chat/presentation/blocs/chat_message_bloc/chat_message_bloc.dart';
import 'package:perfect_super_admin/features/chat/presentation/widgets/message_box.dart';
import 'package:perfect_super_admin/features/chat/presentation/widgets/message_box_shimmer.dart';



class ChatScreen extends StatelessWidget {
  final String recevierId;
  final String receiverName;

  ChatScreen({
    super.key,
    required this.recevierId,
    required this.receiverName,
  });

  final TextEditingController _msgcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<ChatMessageBloc>().add(LoadMessagesEvent(recevierId));
    return Scaffold(
      backgroundColor: PColors.backgrndPrimary,
      appBar: CustomAppBar(title: receiverName),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageBox(context),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return BlocBuilder<ChatMessageBloc, ChatMessageState>(
      builder: (context, state) {
        if (state is MessagesLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            reverse: true,
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              final msg = state.messages[state.messages.length - 1 - index];
              bool isSender = msg["receiverID"] != recevierId;
              return MessageBox(
                msg: msg["message"],
                isSender: isSender,
              );
            },
          );
        } else if (state is MessagesLoading) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            itemCount: 13,
            reverse: true,
            itemBuilder: (context, index) {
              // Alternate shimmer bubbles left/right
              bool isSender = index % 2 == 0;
              return MessageBoxShimmer(isSender: isSender);
            },
          );
        } else if (state is MessagesError) {
          return Center(child: Text("Error: ${state.error}"));
        }
        return const Center(child: Text("No messages yet"));
      },
    );
  }

  Widget _buildMessageBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: PColors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, -2))
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _msgcontroller,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 24,
              backgroundColor: PColors.primaryVariant,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  if (_msgcontroller.text.trim().isNotEmpty) {
                    context.read<ChatMessageBloc>().add(SendMessageEvent(
                        recevierId,
                        _msgcontroller.text.trim()
                     ));
                    _msgcontroller.clear();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
