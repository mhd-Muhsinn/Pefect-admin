import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/features/communication/data/helpers/user_data_helper.dart';
import 'package:perfect_super_admin/features/communication/presentation/blocs/chat_bloc/chat_bloc.dart';
import 'package:perfect_super_admin/features/communication/presentation/blocs/search_cubit/search_cubit.dart';
import 'package:perfect_super_admin/modules/custom_text_field/widget/text_field.dart';
import 'package:perfect_super_admin/modules/dynamic_dropdown/widget/admin_panel_logo_widget.dart';

import '../widgets/chat_user_tile.dart';
import '../widgets/user_tile_shimmer.dart';

class UsersTrainersPage extends StatelessWidget {
  const UsersTrainersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: PColors.white,
        body: Column(
          children: [
            // Header with search
            const MessagesHeader(),
    
            // Tab bar & content
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: PColors.backgrndPrimary),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    // Custom Tab Bar
                    const TabBarSection(),
                    // Tab Views
                    const Expanded(
                      child: TabBarView(
                        children: [
                          TrainersTab(),
                          UsersTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// --- HEADER
class MessagesHeader extends StatefulWidget {
  const MessagesHeader({super.key});
  @override
  State<MessagesHeader> createState() => _MessagesHeaderState();
}

class _MessagesHeaderState extends State<MessagesHeader> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveConfig size = ResponsiveConfig(context);
    return Container(
      padding: EdgeInsets.all(size.percentWidth(0.05)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PColors.primary,
            PColors.primaryVariant.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: PColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.message_sharp,
                  color: PColors.white,
                  size: 28,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: PColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AdminPanelSettingsLogoWidget(),
              ),
            ],
          ),
          const Text(
            'Messages',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<SearchCubit, String>(
            builder: (context, query) {
              final showClear = query.isNotEmpty;
              return CustomTextFormField(
                controller: _searchController,
                hintText: 'Search trainers or users...',
                prefixIcon: Icons.search,
                keyboardType: TextInputType.text,
                onchanged: (val) {
                  // push the query to cubit (ensure null-safe)
                  context.read<SearchCubit>().setQuery(val ?? '');
                },
                suffixIcon: showClear
                    ? IconButton(
                        icon: Icon(Icons.clear, color: PColors.grey),
                        onPressed: () {
                          _searchController.clear();
                          context.read<SearchCubit>().clear();
                        },
                      )
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}

// TAB BAR WIDGET
class TabBarSection extends StatelessWidget {
  const TabBarSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: PColors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: PColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: PColors.primaryVariant,
        unselectedLabelColor: PColors.black,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        tabs: const [
          Tab(text: 'Tutors'),
          Tab(text: 'Users'),
        ],
      ),
    );
  }
}

/// --- TRAINERS TAB ---
class TrainersTab extends StatelessWidget {
  const TrainersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final searchQuery = context.select((SearchCubit sc) => sc.state);

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state.isTrainersLoading) {
          return UserTileShimmer();
        }

        if (state.trainers.isEmpty) {
          return _emptyState('No trainers available', Icons.people_outline);
        }

        final filtered = state.trainers.where((trainer) {
          final name = UserDataHelper.nameLower(trainer);
          final email = UserDataHelper.emailLower(trainer);
          if (searchQuery.isEmpty) return true;
          return name.contains(searchQuery) || email.contains(searchQuery);
        }).toList();

        if (filtered.isEmpty) {
          return _emptyState('No trainers found', Icons.person_search);
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            return UserListItem(
              userData: filtered[index],
              isTrainer: true,
            );
          },
        );
      },
    );
  }
}

/// --- USERS TAB ---
class UsersTab extends StatelessWidget {
  const UsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final searchQuery = context.select((SearchCubit sc) => sc.state);

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state.isUsersLoading) {
          return UserTileShimmer();
        }

        if (state.users.isEmpty) {
          return _emptyState('No users available', Icons.people_outline);
        }

        final filtered = state.users.where((user) {
          final name = UserDataHelper.nameLower(user);
          final email = UserDataHelper.emailLower(user);
          if (searchQuery.isEmpty) return true;
          return name.contains(searchQuery) || email.contains(searchQuery);
        }).toList();

        if (filtered.isEmpty) {
          return _emptyState('No users found', Icons.person_search);
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            return UserListItem(
              userData: filtered[index],
              isTrainer: false,
            );
          },
        );
      },
    );
  }
}

//empty state whether there is no tutor or user
Widget _emptyState(String message, IconData icon) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 80, color: PColors.grey[300]),
        const SizedBox(height: 16),
        Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: PColors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
