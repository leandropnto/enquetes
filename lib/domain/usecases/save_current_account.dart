import 'package:enquetes/domain/core/core.dart';

import '../entities/entities.dart';

abstract class SaveCurrentAccount {
  Future<Either<ValueFailure, Unit>> save(AccountEntity account);
}
