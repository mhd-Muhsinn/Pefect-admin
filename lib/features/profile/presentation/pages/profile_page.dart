import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_super_admin/features/auth/presentation/bloc/bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          onPressed: () {
            context.read<AuthBloc>().add(LogOutEvent());
            Navigator.pushNamedAndRemoveUntil(context, '/login',(route)=>false);
            
          },
          child: Text('Logout')),
    );
  }
}
