import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../data/helpers/user_data_helper.dart';
import '../../data/services/chat/chat_service.dart';
import '../pages/chat_page.dart';

class UserListItem extends StatelessWidget {
  final Map<String, dynamic> userData;
  final bool isTrainer;

  const UserListItem({
    super.key,
    required this.userData,
    required this.isTrainer,
  });

  @override
  Widget build(BuildContext context) {
    final name = UserDataHelper.name(userData);
    final imageUrl = UserDataHelper.imageUrl(userData);
    final uid = userData['uid'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  recevierId: uid,
                  receiverName: name,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Avatar
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isTrainer
                              ? PColors.primaryVariant
                              : Colors.blue.shade300,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey[200],
                        backgroundImage:
                            imageUrl != null ? NetworkImage(imageUrl) : null,
                        child: imageUrl == null
                            ? Text(
                                name.isNotEmpty
                                    ? name[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: isTrainer
                                      ? PColors.primaryVariant
                                      : Colors.blue.shade700,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NAME + TUTOR TAG
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isTrainer)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: PColors.primaryVariant.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Tutor',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: PColors.primaryVariant,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // 🔥 LAST MESSAGE (NEW, MINIMAL)
                      StreamBuilder<Map<String, dynamic>?>(
                        stream: ChatService().getLastMessageForUser(uid),
                        builder: (context, snapshot) {
                          final lastMessage =
                              snapshot.data?['lastMessage'] ??
                                  'No messages yet';

                          return Text(
                            lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

