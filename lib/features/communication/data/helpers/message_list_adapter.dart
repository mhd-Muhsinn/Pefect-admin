import 'package:cloud_firestore/cloud_firestore.dart';
import 'message_utils.dart';

class AdaptedMessage {
  final dynamic raw;
  final int index;
  final bool isSender;
  final String formattedTime;
  final String dateLabel;
  final bool showDateSeparator;

  AdaptedMessage({
    required this.raw,
    required this.index,
    required this.isSender,
    required this.formattedTime,
    required this.dateLabel,
    required this.showDateSeparator,
  });
}

class MessageListAdapter {
  static List<AdaptedMessage> adapt({
    required List messages,
    required String receiverId,
  }) {
    if (messages.isEmpty) return [];

    // Reverse list for UI
    final reversed = List.from(messages.reversed);

    return List.generate(reversed.length, (index) {
      final msg = reversed[index];

      final isSender = msg["senderId"] != receiverId;

      final formattedTime = MessageUtils.formatTime(msg["timestamp"]);
      final dateLabel = MessageUtils.dateLabel(msg["timestamp"]);

      final showSeparator =
          MessageUtils.shouldShowDateSeparator(currIndex: index, messages: reversed);

      return AdaptedMessage(
        raw: msg,
        index: index,
        isSender: isSender,
        formattedTime: formattedTime,
        dateLabel: dateLabel,
        showDateSeparator: showSeparator,
      );
    });
  }
}
