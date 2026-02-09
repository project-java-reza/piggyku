import 'package:finai_frontend/app/data/models/auth/login_model.dart';
import 'package:finai_frontend/app/domain/entities/user.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthInitial && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthLoading && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class LoginSuccess extends AuthState {
  final LoginModel data;

  const LoginSuccess({required this.data});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginSuccess && runtimeType == other.runtimeType && data == other.data;

  @override
  int get hashCode => data.hashCode;
}

class RegisterSuccess extends AuthState {
  final String message;

  const RegisterSuccess({required this.message});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegisterSuccess && runtimeType == other.runtimeType && message == other.message;

  @override
  int get hashCode => message.hashCode;
}

class UserLoaded extends AuthState {
  final User? user;

  const UserLoaded({required this.user});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLoaded && runtimeType == other.runtimeType && user == other.user;

  @override
  int get hashCode => user.hashCode;
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

class LoginFailed extends AuthState {
  final String message;

  const LoginFailed({required this.message});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginFailed &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
