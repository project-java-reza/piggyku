import 'package:bloc/bloc.dart';
import 'package:finai_frontend/app/data/models/auth/login_model.dart';
import 'package:finai_frontend/app/domain/use_cases/auth/login.dart';
import 'package:finai_frontend/app/domain/entities/user.dart';
import 'package:finai_frontend/core/translator/translator.dart';
import 'package:finai_frontend/core/util/security.dart';
import 'package:finai_frontend/core/config/app_config.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._login) : super(const AuthInitial());
  final Login _login;

  /// Login with email and password
  Future<void> login({required String email, required String password}) async {
    print('🔐 AuthCubit: Login attempt with email: $email');
    emit(const AuthLoading());

    // Mock mode for development testing
    print('🔍 AuthCubit: MockConfig.isEnabled: ${MockConfig.isEnabled}');
    print('🔍 AuthCubit: Environment: ${AppConfig.environment}');

    if (MockConfig.isEnabled) {
      print('🚀 AuthCubit: Using mock login');
      await _handleMockLogin(email, password);
      return;
    }

    try {
      final params = LoginParams(
        email: Security.encryptAes(email) ?? '',
        password: Security.encryptAes(password) ?? '',
      );

      final result = await _login(params);

      result.fold(
        (error) {
          emit(LoginFailed(message: error.message ?? translator.internalServerError));
        },
        (loginModel) {
          emit(LoginSuccess(data: loginModel));
        },
      );
    } catch (e) {
      // Handle network errors more gracefully
      String errorMessage = 'An unexpected error occurred';

      if (e.toString().contains('SocketException') ||
          e.toString().contains('failed host lookup')) {
        errorMessage = 'Unable to connect to server. Please check your internet connection and try again.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.toString().contains('Connection refused')) {
        errorMessage = 'Server is not responding. Please try again later.';
      }

      emit(LoginFailed(message: errorMessage));
    }
  }

  /// Handle mock login for development
  Future<void> _handleMockLogin(String email, String password) async {
    print('🧪 AuthCubit: Mock login started');
    print('📧 AuthCubit: Input email: $email');
    print('🔑 AuthCubit: Input password: $password');
    print('✅ AuthCubit: Expected email: ${MockConfig.email}');
    print('✅ AuthCubit: Expected password: ${MockConfig.password}');

    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    if (email == MockConfig.email && password == MockConfig.password) {
      print('✅ AuthCubit: Mock credentials match!');

      // Create mock login model
      final mockUser = User(
        userId: 1,
        username: email,
        name: '6s User',
        role: 'user',
      );

      final mockLoginModel = LoginModel(user: mockUser);
      print('✅ AuthCubit: Emitting LoginSuccess');
      emit(LoginSuccess(data: mockLoginModel));
    } else {
      print('❌ AuthCubit: Mock credentials mismatch');
      emit(const LoginFailed(
        message: 'Invalid credentials. Use test@example.com / password123 for mock login',
      ));
    }
  }

  /// Register with name, email, password
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(const AuthLoading());

    try {
      if (password != passwordConfirmation) {
        emit(const AuthError(message: 'Passwords do not match'));
        return;
      }

      if (password.length < 8) {
        emit(const AuthError(message: 'Password must be at least 8 characters'));
        return;
      }

      // TODO: Implement actual registration use case
      // For now, simulate registration success
      await Future.delayed(const Duration(seconds: 1));

      emit(const RegisterSuccess(message: 'Registration successful! Please login.'));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Logout user - emit initial state
  void logout() {
    emit(const AuthInitial());
  }

  /// Check authentication status - validates stored tokens/user session
  Future<void> checkAuthStatus() async {
    try {
      // TODO: Implement actual token validation logic
      // For now, simulate checking stored session
      await Future.delayed(const Duration(milliseconds: 500));

      // For demo purposes, emit initial state (not authenticated)
      // In real app, you'd check stored tokens and emit appropriate state
      emit(const AuthInitial());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Get current authenticated user
  Future<void> getCurrentUser() async {
    emit(const AuthLoading());

    try {
      // TODO: Implement actual get current user use case
      // For now, simulate fetching user data
      await Future.delayed(const Duration(seconds: 1));

      // For demo purposes, emit user as null
      // In real app, you'd fetch user data from API/local storage
      emit(const UserLoaded(user: null));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Clear any error state
  void clearError() {
    if (state is LoginFailed || state is AuthError) {
      emit(const AuthInitial());
    }
  }

  /// Get current state convenience methods
  bool get isLoading => state is AuthLoading;
  bool get isAuthenticated => state is LoginSuccess;
  bool get hasError => state is LoginFailed || state is AuthError;

  /// Get error message if any
  String? get errorMessage {
    if (state is LoginFailed) {
      return (state as LoginFailed).message;
    }
    if (state is AuthError) {
      return (state as AuthError).message;
    }
    return null;
  }

  /// Get current user data if authenticated
  dynamic get currentUser {
    if (state is LoginSuccess) {
      return (state as LoginSuccess).data.user;
    }
    if (state is UserLoaded) {
      return (state as UserLoaded).user;
    }
    return null;
  }
}
