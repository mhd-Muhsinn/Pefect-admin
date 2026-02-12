import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';

import '../../../../modules/custom_text_field/widget/text_field.dart';
import '../../data/models/admin_user_model.dart';
import '../blocs/admin_user/admin_user_bloc.dart';
import 'user_detail_page.dart';


class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AdminUserBloc>().add(LoadAllUsersEvent());
  }
  List<AdminUserModel> _filteredUsers(
  List<AdminUserModel> users,
  String query,
) {
  if (query.isEmpty) return users;

  final q = query.toLowerCase();
  return users.where((u) {
    return u.name.toLowerCase().contains(q) ||
        u.email.toLowerCase().contains(q) ||
        u.phone.contains(q);
  }).toList();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: PColors.primary,
      ),
      body: Column(
        children: [
          _buildSearch(),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  // 🔍 SEARCH BOX
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: CustomTextFormField(
        controller: _searchController,
        hintText: 'Search by name, email or phone',
        prefixIcon: Icons.search,
        onchanged: (value) {
          setState(() {
          });
        },
      ),
    );
  }

  // 👥 USER LIST
  Widget _buildUserList() {
    return BlocBuilder<AdminUserBloc, AdminUserState>(
      builder: (context, state) {
        if (state is AdminUserLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AdminUserLoaded) {
          if (state.users.isEmpty) {
            return const Center(child: Text('No users found'));
          }
            final users =
      _filteredUsers(state.users, _searchController.text);
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return _userCard(state.users[index]);
            },
          );
        }

        if (state is AdminUserError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox.shrink();
      },
    );
  }

  // 🧾 USER CARD
  Widget _userCard(AdminUserModel user) {
    final bool isBlocked = user.status == 'blocked';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isBlocked
          ? Colors.red.shade50
          : PColors.containerBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isBlocked ? Colors.red : PColors.primary,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NAME + STATUS
            Row(
              children: [
                Expanded(
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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

            const SizedBox(height: 6),

            // EMAIL
            Text(
              user.email,
              style: const TextStyle(color: Colors.black87),
            ),

            // PHONE
            if (user.phone.isNotEmpty)
              Text(
                user.phone,
                style: const TextStyle(color: Colors.black54),
              ),

            const SizedBox(height: 8),

            // COURSES COUNT
            Text(
              user.myCourses.isEmpty
                  ? 'No courses purchased'
                  : '${user.myCourses.length} courses purchased',
              style: const TextStyle(fontSize: 13),
            ),

            const Divider(height: 20),

            // ACTIONS
            Row(
              children: [
                // VIEW USER
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserDetailPage(user: user),
                      ),
                    );
                  },
                  child: const Text('View'),
                ),

                const Spacer(),

                // BLOCK / UNBLOCK
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isBlocked ? Colors.green : Colors.red,
                  ),
                  onPressed: () {
                    context.read<AdminUserBloc>().add(
                          isBlocked
                              ? UnblockUserEvent(user.uid)
                              : BlockUserEvent(user.uid),
                        );
                  },
                  child: Text(
                    isBlocked ? 'Unblock' : 'Block',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
