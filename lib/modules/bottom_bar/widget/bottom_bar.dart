import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:perfect_super_admin/features/communication/presentation/pages/users_trainers_page.dart';
import 'package:perfect_super_admin/features/communication/presentation/widgets/incoming_dialog.dart';
import 'package:perfect_super_admin/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:perfect_super_admin/features/activity/presentation/pages/acitivty_type_page.dart';
import 'package:perfect_super_admin/features/manage/presentation/pages/manage_main_page.dart';
import 'package:perfect_super_admin/features/profile/presentation/pages/profile_page.dart';
import 'package:perfect_super_admin/modules/bottom_bar/cubit/bottom_bar_cubit.dart';

// ✅ Add these imports
import 'package:perfect_super_admin/features/communication/presentation/blocs/call_listener/call_listener_bloc.dart';
import 'package:perfect_super_admin/features/communication/presentation/blocs/call_listener/call_listener_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _GoogleBottomBarState();
}

class _GoogleBottomBarState extends State<BottomBar> {
  final List<Widget> _pages = [
    DashboardScreen(),
    ManageScreen(),
    UsersTrainersPage(),
    ActivityTypePage(),
    AdminProfilePage()
  ];

  String? _currentlyShowingCallId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CallListenerBloc, CallListenerState>(
          listener: (context, state) {
            if (state is IncomingCallState) {
              // Only show dialog if not already showing this call
              if (_currentlyShowingCallId != state.call.id) {
                _currentlyShowingCallId = state.call.id;

                _showIncomingCallDialog(context, state);
              }
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is UnAuthenticated) {
              Navigator.popAndPushNamed(context, '/login');
            }
          },
        ),
      ],
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: BlocBuilder<BottomNavCubit, int>(
          builder: (context, currentIndex) {
            return _pages[currentIndex];
          },
        ),
        bottomNavigationBar: BlocBuilder<BottomNavCubit, int>(
          builder: (context, currentIndex) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: PColors.containerBackground,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  height: 70,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                        context: context,
                        icon: Icons.home_rounded,
                        index: 0,
                        currentIndex: currentIndex,
                      ),
                      _buildNavItem(
                        context: context,
                        icon: Icons.dashboard_customize,
                        index: 1,
                        currentIndex: currentIndex,
                      ),
                      _buildNavItem(
                        context: context,
                        icon: Icons.message,
                        index: 2,
                        currentIndex: currentIndex,
                      ),
                      _buildNavItem(
                        context: context,
                        icon: Icons.edit_note_rounded,
                        index: 3,
                        currentIndex: currentIndex,
                      ),
                      _buildNavItem(
                        context: context,
                        icon: Icons.person_rounded,
                        index: 4,
                        currentIndex: currentIndex,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Show incoming call dialog
  void _showIncomingCallDialog(BuildContext context, IncomingCallState state) {
    // Get current user name (adjust based on your auth/profile setup)
    final currentUserName =
        FirebaseAuth.instance.currentUser?.displayName ?? 'Admin';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => WillPopScope(
        onWillPop: () async => false, // Prevent back button dismiss
        child: IncomingCallDialog(
          call: state.call,
          callerName: state.call.callerName ?? 'Unknown Caller',
          currentUserName: currentUserName,
        ),
      ),
    ).then((_) {
      // Dialog closed - reset tracking
      setState(() {
        _currentlyShowingCallId = null;
      });
    });
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required int index,
    required int currentIndex,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => context.read<BottomNavCubit>().updateIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
          size: isSelected ? 28 : 24,
        ),
      ),
    );
  }
}
