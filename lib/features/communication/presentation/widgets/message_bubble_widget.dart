import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';

import '../../data/helpers/message_utils.dart';

class MessageBubbleWidget extends StatelessWidget {
  final String message;
  final bool isSender;
  final dynamic timestamp;

  const MessageBubbleWidget({
    Key? key,
    required this.message,
    required this.isSender,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSender
                    ? LinearGradient(
                        colors: [
                          PColors.primaryVariant,
                          PColors.primaryVariant.withOpacity(0.9),
                        ],
                      )
                    : null,
                color: isSender ? null : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isSender ? 20 : 4),
                  bottomRight: Radius.circular(isSender ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 15,
                      color: isSender ? Colors.white : Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timestamp,
                        style: TextStyle(
                          fontSize: 11,
                          color: isSender
                              ? Colors.white.withOpacity(0.8)
                              : Colors.grey[600],
                        ),
                      ),
                      if (isSender) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.done_all,
                          size: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
