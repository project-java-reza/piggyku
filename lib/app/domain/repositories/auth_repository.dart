import 'package:dartz/dartz.dart';
import 'package:finai_frontend/app/data/models/auth/login_model.dart';
import 'package:finai_frontend/app/data/models/error_model.dart';

abstract class AuthRepository {
  Future<Either<ErrorModel, LoginModel>> login(LoginParams params);
}
