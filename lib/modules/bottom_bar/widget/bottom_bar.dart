import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/features/chat/presentation/pages/users_trainers_page.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:perfect_super_admin/features/edit/presentation/pages/edit_main_page.dart';
import 'package:perfect_super_admin/features/manage/presentation/pages/manage_main_page.dart';
import 'package:perfect_super_admin/features/profile/presentation/pages/profile_page.dart';
import 'package:perfect_super_admin/modules/bottom_bar/cubit/bottom_bar_cubit.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _GoogleBottomBarState();
}

class _GoogleBottomBarState extends State<BottomBar> {
  final List<Widget> _pages =  [
    DashboardScreen(),
    ManageScreen(),
    UsersTrainersPage(),
    EditMainPage(),
    ProfilePage()
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomNavCubit, int>(
        builder: (context, currentIndex) {
          return _pages[currentIndex];
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomNavCubit, int>(
        builder: (context, currentIndex) {
          return SalomonBottomBar(
            backgroundColor: PColors.backgrndPrimary,
            currentIndex: currentIndex,
            onTap: (index) => context.read<BottomNavCubit>().updateIndex(index),
            items: _buildBottomBarItems(),
          );
        },
      ),
    );
  }

  List<SalomonBottomBarItem> _buildBottomBarItems() {
    return [
      SalomonBottomBarItem(
        icon: const Icon(Icons.home),
        title: const Text("Home"),
        selectedColor: PColors.primary,
      ),
      SalomonBottomBarItem(
        icon: const Icon(Icons.manage_accounts),
        title: const Text("Manage"),
        selectedColor: PColors.primary,
      ),
      SalomonBottomBarItem(
        icon: const Icon(Icons.chat),
        title: const Text("Chat"),
        selectedColor: PColors.primary,
      ),
      SalomonBottomBarItem(
        icon: const Icon(Icons.edit),
        title: const Text("Edit"),
        selectedColor: PColors.primary,
      ),
      SalomonBottomBarItem(
        icon: const Icon(Icons.person),
        title: const Text("profile"),
        selectedColor: PColors.primary,
      ),
    ];
  }
}