import 'package:bloc/bloc.dart';
import 'package:perfect_super_admin/features/manage/data/models/admin_user_model.dart';

import '../../../domain/repositories/admin_user_repository.dart';

part 'admin_user_event.dart';
part 'admin_user_state.dart';

class AdminUserBloc extends Bloc<AdminUserEvent, AdminUserState> {
  final AdminUserRepository repository;



  AdminUserBloc(this.repository) : super(AdminUserInitial()) {
    on<LoadAllUsersEvent>(_onLoadUsers);
    on<BlockUserEvent>(_onBlockUser);
    on<UnblockUserEvent>(_onUnblockUser);
  }

Future<void> _onLoadUsers(
  LoadAllUsersEvent event,
  Emitter<AdminUserState> emit,
) async {
  emit(AdminUserLoading());

  await emit.forEach<List<AdminUserModel>>(
    repository.fetchUsers(),
    onData: (users) => AdminUserLoaded(users),
    onError: (error, _) => AdminUserError(error.toString()),
  );
}


  Future<void> _onBlockUser(
    BlockUserEvent event,
    Emitter<AdminUserState> emit,
  ) async {
    await repository.blockUser(event.userId);
  }

  //UNBLOCK 
  Future<void> _onUnblockUser(
    UnblockUserEvent event,
    Emitter<AdminUserState> emit,
  ) async {
    await repository.unblockUser(event.userId);
  }
}
