part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);
}

class UnAuthenticated extends AuthState {
  final String? message;
  UnAuthenticated({this.message});
}

class AuthenticatedErrors extends AuthState {
  final String message;
  AuthenticatedErrors({required this.message});
}

class LoginCredentialsNotFound extends AuthState {
  final String message;
  LoginCredentialsNotFound({required this.message});
}



