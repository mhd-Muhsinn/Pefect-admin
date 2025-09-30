import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/features/chat/presentation/blocs/bloc/chat_bloc.dart';
import 'package:perfect_super_admin/features/chat/presentation/blocs/chat_message_bloc/chat_message_bloc.dart';
import 'package:perfect_super_admin/modules/custom_text_field/widget/text_field.dart';

class ChatPage extends StatelessWidget {
  final String name;
  final String receiverId;
  ChatPage({super.key, required this.name, required this.receiverId});

  //message controller
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<ChatMessageBloc>().add(LoadMessagesEvent(receiverId));
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Column(
        children: [
          //fetchh messages..
          Expanded(child: _buildMessageList()),

          //inputbox
          _buildMessageBox(context)
        ],
      ),
    );
  }

  //all messages build widget
  Widget _buildMessageList() {
    return BlocBuilder<ChatMessageBloc, ChatMessageState>(
      builder: (context, state) {
        if (state is MessagesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MessagesLoaded) {
          return ListView(
              children:
                  state.messages.map((msg) => _buildMessageItem(msg)).toList());
        } else if (state is MessagesError) {
          return Text("Error: ${state.error}");
        }
        return const Center(child: Text("No messages yet"));
      },
    );
  }

  //each messge item
  Widget _buildMessageItem(Map<String, dynamic> msg) {
    //message alignment
    bool isAdmin = msg["senderID"] == receiverId;

    var alignment = isAdmin ? Alignment.centerLeft : Alignment.centerRight;

    return Container(
        alignment: alignment,
        margin: EdgeInsets.only(right: 25),
        child: Text(msg["message"]));
  }

  Widget _buildMessageBox(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextFormField(
            hintText: "Type Something..",
            prefixIcon: Icons.message,
            controller: _messageController,
          ),
        ),
        IconButton(
            onPressed: () {
              context
                  .read<ChatMessageBloc>()
                  .add(SendMessageEvent(receiverId, _messageController.text));

              _messageController.clear();
            },
            icon: Icon(Icons.send))
      ],
    );
  }
}
