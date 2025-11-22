import 'package:dartz/dartz.dart';
import 'package:finai_frontend/app/data/data_sources/auth_data_source.dart';
import 'package:finai_frontend/app/data/models/auth/login_model.dart';
import 'package:finai_frontend/app/data/models/error_model.dart';
import 'package:finai_frontend/app/domain/repositories/auth_repository.dart';
import 'package:finai_frontend/core/exceptions/exceptions.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;
  AuthRepositoryImpl(this.dataSource);

  @override
  Future<Either<ErrorModel, LoginModel>> login(LoginParams params) async {
    try {
      return Right(await dataSource.login(params));
    } on ServerException catch (e) {
      return Left(e.responseError);
    }
  }
}
