import 'package:dartz/dartz.dart';
import 'package:finai_frontend/app/data/models/error_model.dart';

abstract class UseCase<Type, Params> {
  Future<Either<ErrorModel, Type>> call(Params params);
}
