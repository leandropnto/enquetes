import 'package:enquetes/domain/entities/entities.dart';
import 'package:enquetes/domain/helpers/domain_error.dart';
import 'package:enquetes/domain/usecases/load_current_account.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

abstract class FetchSecureCacheStorage {
  Future<String> fetchSecure(String key);
}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({this.fetchSecureCacheStorage});

  Future<AccountEntity> load() async {
    try {
      final strToken = await fetchSecureCacheStorage.fetchSecure('token');
      return AccountEntity(strToken);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}

void main() {
  //Variables
  LocalLoadCurrentAccount sut;
  FetchSecureCacheStorage fetchSecureCacheStorage;
  String token;
  //Mocks

  void mockLoadCurrentAccount(String token) {
    when(fetchSecureCacheStorage.fetchSecure('token'))
        .thenAnswer((_) async => token);
  }
  //helpers

  void mockLoadError() {
    when(fetchSecureCacheStorage.fetchSecure(any)).thenThrow(Exception());
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
        fetchSecureCacheStorage: fetchSecureCacheStorage);
    token = faker.guid.guid();
    mockLoadCurrentAccount(token);
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('Should return an AccountEntity', () async {
    final account = await sut.load();
    expect(account, AccountEntity(token));
  });

  test('Should throw UnexpectedError if fetchSecureCacheStorage throws',
      () async {
    mockLoadError();
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });
}
