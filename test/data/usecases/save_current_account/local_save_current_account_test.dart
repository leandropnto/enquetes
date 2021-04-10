import 'package:enquetes/data/cache/cache.dart';
import 'package:enquetes/data/usecases/usecases.dart';
import 'package:enquetes/domain/core/core.dart';
import 'package:enquetes/domain/core/either.dart';
import 'package:enquetes/domain/core/unit.dart';
import 'package:enquetes/domain/core/value_failure.dart';
import 'package:enquetes/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

void main() {
  SaveSecureCacheStorageSpy saveSecureCacheStorage =
      SaveSecureCacheStorageSpy();
  LocalSaveCurrentAccount sut =
      LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
  AccountEntity account = AccountEntity(Token.of(faker.guid.guid()));

  void mockError(SaveSecureCacheStorageSpy saveSecureCacheStorage) async {
    when(saveSecureCacheStorage.saveSecure(
            key: anyNamed('key') ?? "", value: anyNamed('value') ?? ""))
        .thenAnswer((_) => Future.delayed(Duration.zero,
            () => ValueFailure.unexpectedError(Exception()).left()));
  }

  test('Should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);

    verify(saveSecureCacheStorage.saveSecure(
        key: 'token', value: account.token.getOrCrash()));
  });

  test(
      'Should return left ValueFailure SaveSecureCacheStorage '
      'throws', () async {
    final saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    mockError(saveSecureCacheStorage);
    final sut =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    final account = AccountEntity(Token.of(faker.guid.guid()));

    final future = await sut.save(account);

    expect(future, isA<Either<ValueFailure, Unit>>());
    future.fold((failure) => expect(failure, isA<ValueFailure>()), (_) => null);
  });
}
