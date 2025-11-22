import 'dart:convert';
import 'package:finai_frontend/app/data/models/auth/login_model.dart';
import 'package:finai_frontend/app/domain/entities/constant.dart';
import 'package:finai_frontend/core/services/api_service.dart';
import 'package:finai_frontend/core/services/injection.dart';
import 'package:injectable/injectable.dart';

abstract class AuthDataSource {
  Future<LoginModel> login(LoginParams params);
}

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  var apiService = getIt<ApiService>();
  @override
  Future<LoginModel> login(LoginParams params) async {
    final response = await apiService.connect(
        Constant.login, await params.toJson(), Constant.post);
    return loginModelFromJson(jsonEncode(response.data));
  }
}
