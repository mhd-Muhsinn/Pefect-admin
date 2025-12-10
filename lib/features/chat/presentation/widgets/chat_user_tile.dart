import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/features/chat/presentation/pages/chat_page.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.UserOrtutor,
  });

  final Map<String, dynamic> UserOrtutor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: PColors.backgrndPrimary,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(Icons.person),
        title: Text(
          UserOrtutor["name"],
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          UserOrtutor["email"],
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.call, color: PColors.containerBackground),
          onPressed: () {
            // TODO: implement audio call feature
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Audio call feature coming soon!"),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(recevierId: UserOrtutor['uid'], receiverName: UserOrtutor['name'],
                
              ),
            ),
          );
        },
      ),
    );
  }
}
