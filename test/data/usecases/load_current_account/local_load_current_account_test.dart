import 'package:enquetes/data/cache/cache.dart';
import 'package:enquetes/data/usecases/usecases.dart';
import 'package:enquetes/domain/entities/entities.dart';
import 'package:enquetes/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  //Variables
  FetchSecureCacheStorage fetchSecureCacheStorage =
      FetchSecureCacheStorageSpy();
  LocalLoadCurrentAccount sut =
      LocalLoadCurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);
  String token = faker.guid.guid();
  //Mocks

  void mockLoadCurrentAccount(String token) {
    when(fetchSecureCacheStorage.fetchSecure('token'))
        .thenAnswer((_) async => token);
  }
  //helpers

  void mockLoadError() {
    when(fetchSecureCacheStorage.fetchSecure("")).thenThrow(Exception());
  }

  setUp(() {
    mockLoadCurrentAccount(token);
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('Should return an AccountEntity', () async {
    final account = await sut.load();
    expect(account, AccountEntity(Token.of(token)));
  });

  test('Should throw UnexpectedError if fetchSecureCacheStorage throws',
      () async {
    mockLoadError();
    final future = sut.load();
    expect(future, throwsA(DomainError.unexpected));
  });
}
