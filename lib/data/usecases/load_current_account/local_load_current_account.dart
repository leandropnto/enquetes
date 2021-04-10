import 'package:enquetes/data/cache/cache.dart';
import 'package:enquetes/domain/entities/entities.dart';
import 'package:enquetes/domain/helpers/helpers.dart';
import 'package:enquetes/domain/usecases/usecases.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({required this.fetchSecureCacheStorage});

  Future<AccountEntity> load() async {
    try {
      final strToken = await fetchSecureCacheStorage.fetchSecure('token');
      return AccountEntity(Token.of(strToken));
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
