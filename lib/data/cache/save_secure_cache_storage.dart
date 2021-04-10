import 'package:enquetes/domain/core/either.dart';
import 'package:enquetes/domain/core/unit.dart';
import 'package:enquetes/domain/core/value_failure.dart';

abstract class SaveSecureCacheStorage {
  Future<Either<ValueFailure, Unit>> saveSecure({
    required String key,
    required String value,
  });
}
