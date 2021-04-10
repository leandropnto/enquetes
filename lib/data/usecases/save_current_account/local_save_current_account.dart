import 'package:enquetes/domain/core/core.dart';
import 'package:enquetes/domain/usecases/usecases.dart';

import '../../../domain/entities/entities.dart';
import '../../cache/cache.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({required this.saveSecureCacheStorage});

  Future<Either<ValueFailure, Unit>> save(AccountEntity account) async =>
      saveSecureCacheStorage.saveSecure(
          key: 'token', value: account.token.getOrCrash());
}
