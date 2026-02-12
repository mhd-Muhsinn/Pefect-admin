import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/features/communication/presentation/blocs/call_action/call_action_bloc.dart';
import 'package:perfect_super_admin/features/communication/presentation/blocs/call_action/call_action_event.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String receiverName;
  final String receiverId;

  const ChatAppBar(
      {super.key, required this.receiverName, required this.receiverId});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: PColors.primaryVariant.withOpacity(0.1),
            child: Text(
              receiverName[0].toUpperCase(),
              style: TextStyle(
                color: PColors.primaryVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              receiverName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        InkWell(
            onTap: () {
              context.read<CallActionBloc>().add(
                  StartCallEvent(receiverId: receiverId, callType: 'video', callerName: receiverName));
            },
            child: const Icon(Icons.videocam, color: Colors.black87)),
        const SizedBox(width: 10),
         InkWell(
          onTap: () {
              context.read<CallActionBloc>().add(
                  StartCallEvent(receiverId: receiverId, callType: 'audio', callerName: receiverName));
            },
          child: Icon(Icons.phone, color: Colors.black87)),
        const SizedBox(width: 10),
        const Icon(Icons.more_vert, color: Colors.black87),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
