part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class LoginSuccess extends AuthState {
  final LoginModel data;
  LoginSuccess(this.data);
}

final class LoginFailed extends AuthState {
  final String message;
  LoginFailed(this.message);
}
