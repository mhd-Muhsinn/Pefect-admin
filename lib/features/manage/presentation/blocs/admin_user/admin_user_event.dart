part of 'admin_user_bloc.dart';

abstract class AdminUserEvent {}

class LoadAllUsersEvent extends AdminUserEvent {}

class BlockUserEvent extends AdminUserEvent {
  final String userId;
  BlockUserEvent(this.userId);
}

class UnblockUserEvent extends AdminUserEvent {
  final String userId;
  UnblockUserEvent(this.userId);
}


