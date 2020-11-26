import 'package:enquetes/domain/core/either.dart';
import 'package:enquetes/domain/core/unit.dart';
import 'package:enquetes/domain/core/value_failure.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import '../../data/cache/cache.dart';

class LocalStorageAdapter
    implements SaveSecureCacheStorage, FetchSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter({@required this.secureStorage});

  @override
  Future<Either<ValueFailure, Unit>> saveSecure(
      {@required String key, @required String value}) async {
    try {
      await secureStorage.write(key: key, value: value);
      return unit.right();
    } catch (e) {
      return ValueFailure.unexpectedError(e).left();
    }
  }

  @override
  Future<String> fetchSecure(String key) async {
    return await secureStorage.read(key: key);
  }
}
