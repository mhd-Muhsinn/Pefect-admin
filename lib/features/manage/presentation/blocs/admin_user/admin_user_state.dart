part of 'admin_user_bloc.dart';

abstract class AdminUserState {}

class AdminUserInitial extends AdminUserState {}

class AdminUserLoading extends AdminUserState {}

class AdminUserLoaded extends AdminUserState {
  final List<AdminUserModel> users;
  AdminUserLoaded(this.users);
}

class AdminUserError extends AdminUserState {
  final String message;
  AdminUserError(this.message);
}

