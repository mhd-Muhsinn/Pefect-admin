import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import '../../data/models/admin_user_model.dart';
import '../blocs/admin_user/admin_user_bloc.dart';


class UserDetailPage extends StatelessWidget {
  final AdminUserModel user;

  const UserDetailPage({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBlocked = user.status == 'blocked';

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: PColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _headerCard(isBlocked),
          const SizedBox(height: 16),
          _infoCard(),
          const SizedBox(height: 16),
          _coursesCard(),
          const SizedBox(height: 24),
          _blockUnblockButton(context, isBlocked),
        ],
      ),
    );
  }

  // 👤 HEADER
  Widget _headerCard(bool isBlocked) {
    return Card(
      color: isBlocked ? Colors.red.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isBlocked ? Colors.red : PColors.primary,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor:
                  isBlocked ? Colors.red : PColors.primary,
              child: Text(
                user.name.isNotEmpty
                    ? user.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Chip(
                    label: Text(
                      isBlocked ? 'Blocked' : 'Active',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor:
                        isBlocked ? Colors.red : Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ℹ️ BASIC INFO
  Widget _infoCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(height: 24),

            _infoRow('Email', user.email),
            _infoRow('Phone', user.phone.isNotEmpty ? user.phone : '—'),
            _infoRow('User ID', user.uid),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // 📚 COURSES
  Widget _coursesCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Purchased Courses',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(height: 24),

            if (user.myCourses.isEmpty)
              const Text(
                'No courses purchased',
                style: TextStyle(color: Colors.black54),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: user.myCourses.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 16),
                itemBuilder: (context, index) {
                  final courseId = user.myCourses[index];
                  return Row(
                    children: [
                      const Icon(Icons.book, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          courseId,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // 🚫 BLOCK / UNBLOCK
  Widget _blockUnblockButton(
    BuildContext context,
    bool isBlocked,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isBlocked ? Colors.green : Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () {
          context.read<AdminUserBloc>().add(
                isBlocked
                    ? UnblockUserEvent(user.uid)
                    : BlockUserEvent(user.uid),
              );
          Navigator.pop(context); // return to list
        },
        child: Text(
          isBlocked ? 'Unblock User' : 'Block User',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
