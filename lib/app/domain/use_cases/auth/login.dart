import 'package:dartz/dartz.dart';
import 'package:finai_frontend/app/data/models/auth/login_model.dart';
import 'package:finai_frontend/app/data/models/error_model.dart';
import 'package:finai_frontend/app/domain/repositories/auth_repository.dart';
import 'package:finai_frontend/core/use_cases/use_case.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class Login implements UseCase<LoginModel, LoginParams> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<Either<ErrorModel, LoginModel>> call(LoginParams params) async {
    return await repository.login(params);
  }
}
