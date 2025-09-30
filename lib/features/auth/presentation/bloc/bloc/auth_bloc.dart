import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:perfect_super_admin/features/auth/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<CheckLoginStatusEvent>(_checkLoginStatus);
    on<LoginEvent>(_loginEvent);
    on<LogOutEvent>(_signOut);
  }

  Future<void> _signOut(LogOutEvent event, Emitter<AuthState> emit) async {
    try {
      await authRepository.signout();
      emit(UnAuthenticated());
    } catch (e) {
      emit(AuthenticatedErrors(message: e.toString()));
    }
  }

  Future<void> _checkLoginStatus(
      CheckLoginStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(seconds: 5)); // await was missing
      final admin = await authRepository.getadmindetail();

      if (admin != null) {
        emit(Authenticated(admin));
      } else {
        emit(UnAuthenticated());
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthenticatedErrors(message: e.message ?? 'Authentication failed'));
    } catch (e) {
      emit(AuthenticatedErrors(message: e.toString()));
    }
  }

  Future<void> _loginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final user = await authRepository.loginWithEmailandPassword(
        event.email,
        event.password,
      );
      if (user == null) {
        emit(AuthenticatedErrors(
            message: 'Access denied: You are not an admin.'));
        return;
      }

      emit(Authenticated(user!));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthenticatedErrors(message: 'No user found with this email'));
      } else if (e.code == 'wrong-password') {
        emit(AuthenticatedErrors(message: 'Incorrect password'));
      } else if (e.code == 'unauthorized') {
        emit(AuthenticatedErrors(message: 'Access denied: Not an admin'));
      } else {
        emit(AuthenticatedErrors(message: e.message ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthenticatedErrors(
          message: 'Something went wrong: ${e.toString()}'));
    }
  }
}
