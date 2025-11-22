import 'package:bloc/bloc.dart';
import 'package:finai_frontend/app/data/models/auth/login_model.dart';
import 'package:finai_frontend/app/domain/use_cases/auth/login.dart';
import 'package:finai_frontend/core/translator/translator.dart';
import 'package:finai_frontend/core/util/security.dart';
import 'package:flutter/material.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._login) : super(AuthInitial());
  final Login _login;

// example cubit if connect to backend service
  login({required String email, required String password}) async {
    try {
      var params = LoginParams(
          email: Security.encryptAes(email) ?? '',
          password: Security.encryptAes(password) ?? '');
      var res = await _login(params);
      res.fold((l) {
        emit(LoginFailed(l.message ?? translator.internalServerError));
      }, (r) {
        emit(LoginSuccess(r));
      });
    } catch (e) {
      emit(LoginFailed(e.toString()));
    }
  }
}
