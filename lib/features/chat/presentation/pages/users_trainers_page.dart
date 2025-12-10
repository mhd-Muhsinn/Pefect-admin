import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';
import 'package:perfect_super_admin/features/chat/presentation/blocs/bloc/chat_bloc.dart';
import 'package:perfect_super_admin/features/chat/presentation/pages/chat_page.dart';
import 'package:perfect_super_admin/features/chat/presentation/widgets/chat_user_tile.dart';

class UsersTrainersPage extends StatelessWidget {
  const UsersTrainersPage({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveConfig size = ResponsiveConfig(context);
    return Scaffold(
      body: Column(
        children: [
          //Search box

          Expanded(child: _buildTrainersUsersTabar(size, context))
        ],
      ),
    );
  }

  Widget _buildTrainersUsersTabar(ResponsiveConfig size, BuildContext context) {
    return Container(
        height: size.percentHeight(1),
        decoration: BoxDecoration(
          color: PColors.backgrndPrimary,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: PColors.textPrimary),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: PColors.containerBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: PColors.white,
                  unselectedLabelColor: PColors.grey,
                  dividerColor: Colors.transparent,
                  labelPadding:
                      EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  tabs: const [
                    Tab(text: 'Trainers'),
                    Tab(text: 'Users'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [_buildTrainersList(), _buildUsersList()],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildTrainersList() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state.isTrainersLoading) {
          return CircularProgressIndicator();
        } else if (state.trainers.isNotEmpty) {
          return ListView(
            children: state.trainers
                .map<Widget>(
                    (userData) => _buildTrainerUserListItem(userData, context))
                .toList(),
          );
        } else if (state is UsersError) {
          return Text('Error: ${state.error}');
        }
        return Container();
      },
    );
  }

  Widget _buildUsersList() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state.isUsersLoading) {
          print(state.trainers);
          return CircularProgressIndicator();
        }
        if (state.users.isNotEmpty) {
          print(state.trainers);
          return ListView(
            children: state.users
                .map<Widget>(
                    (userData) => _buildTrainerUserListItem(userData, context))
                .toList(),
          );
        } else if (state is UsersError) {
          return Text('Error: ${state.error}');
        }
        return Container();
      },
    );
  }

  Widget _buildTrainerUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    return ChatTile(
        UserOrtutor: userData,
    );
  }
}
