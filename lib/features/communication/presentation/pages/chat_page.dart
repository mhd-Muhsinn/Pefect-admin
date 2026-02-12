import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/features/communication/data/helpers/message_list_adapter.dart';
import 'package:perfect_super_admin/features/communication/presentation/blocs/call_action/call_action_bloc.dart';
import 'package:perfect_super_admin/features/communication/presentation/blocs/chat_message_bloc/chat_message_bloc.dart';
import 'package:perfect_super_admin/features/communication/presentation/pages/outgoing_call_page.dart';
import 'package:perfect_super_admin/features/communication/presentation/widgets/chat_appbar.dart';
import 'package:perfect_super_admin/modules/custom_text_field/widget/text_field.dart';

import '../blocs/call_action/call_action_state.dart';
import '../widgets/message_bubble_widget.dart';

class ChatScreen extends StatefulWidget {
  final String recevierId;
  final String receiverName;

  const ChatScreen({
    super.key,
    required this.recevierId,
    required this.receiverName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatMessageBloc>().add(LoadMessagesEvent(widget.recevierId));
  }

  @override
  void dispose() {
    _msgcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CallActionBloc, CallActionState>(
      listener: (context, state) {
        if (state is CallStarted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OutgoingCallPage(callId: state.call.id, currentUserName: 'ADMIN',),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: ChatAppBar(
          receiverName: widget.receiverName,
          receiverId: widget.recevierId,
        ),
        body: Column(
          children: [
            Expanded(
                child: MessageListSection(
              receiverId: widget.recevierId,
            )),

            //Message Box
            MessageInputBox(
                msgcontroller: _msgcontroller, context: context, widget: widget)
          ],
        ),
      ),
    );
  }
}

//-- MESSAGE LIST
class MessageListSection extends StatelessWidget {
  final String receiverId;
  const MessageListSection({super.key, required this.receiverId});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatMessageBloc, ChatMessageState>(
      builder: (context, state) {
        if (state is MessagesLoaded) {
          if (state.messages.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline,
                      size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'No messages yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start a conversation!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }
          final adaptedList = MessageListAdapter.adapt(
              messages: state.messages, receiverId: receiverId);

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            reverse: true,
            itemCount: adaptedList.length,
            itemBuilder: (context, index) {
              final item = adaptedList[index];

              return Column(
                children: [
                  if (item.showDateSeparator)
                    buildDateSeparator(item.dateLabel),
                  MessageBubbleWidget(
                    message: item.raw["message"],
                    isSender: item.isSender,
                    timestamp: item.formattedTime,
                  ),
                ],
              );
            },
          );
        } else if (state is MessagesLoading) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            itemCount: 8,
            reverse: true,
            itemBuilder: (context, index) {
              return buildMessageShimmer(index.isEven, context);
            },
          );
        } else if (state is MessagesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error loading messages',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.error,
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return const Center(child: Text("No messages yet"));
      },
    );
  }

  Widget buildDateSeparator(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
        ],
      ),
    );
  }

  Widget buildMessageShimmer(bool isSender, BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 80,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//--Message Box
class MessageInputBox extends StatelessWidget {
  const MessageInputBox({
    super.key,
    required TextEditingController msgcontroller,
    required this.context,
    required this.widget,
  }) : _msgcontroller = msgcontroller;
  final TextEditingController _msgcontroller;
  final BuildContext context;
  final ChatScreen widget;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            const SizedBox(width: 8),
            // Text field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: CustomTextFormField(
                  controller: _msgcontroller,
                  hintText: "Type a message...",
                  keyboardType: TextInputType.multiline,
                  maxLength: null,
                  inputFormatters: null,
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {},
                  ),
                  onchanged: (value) {
                    // typing callback if needed
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Send button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    PColors.primaryVariant,
                    PColors.primaryVariant.withOpacity(0.8),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: PColors.primaryVariant.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                onPressed: () {
                  if (_msgcontroller.text.trim().isNotEmpty) {
                    context.read<ChatMessageBloc>().add(
                          SendMessageEvent(
                            widget.recevierId,
                            _msgcontroller.text.trim(),
                          ),
                        );
                    _msgcontroller.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
