import 'package:enquetes/domain/core/core.dart';
import 'package:enquetes/infra/cache/cache.dart';
import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

@GenerateMocks([FlutterSecureStorage])
void main() {
  //Variables
  FlutterSecureStorage secureStorage = FlutterSecureStorageSpy();
  LocalStorageAdapter sut = LocalStorageAdapter(secureStorage: secureStorage);
  String value = faker.lorem.word();
  String key = faker.guid.guid();
  //Mocks
  void mockSaveSecureWriteError() {
    when(secureStorage.write(key: "teste", value: "value"))
        .thenThrow(Exception());
  }

  void mockFetchSecure() {
    when(secureStorage.read(key: anyNamed('key') ?? ""))
        .thenAnswer((_) async => value);
  }

  void mockFetchSecureError() {
    when(secureStorage.read(key: anyNamed('key') ?? "")).thenThrow(Exception());
  }
  //helpers

  //setup
  setUp(() {});

  group('saveSecure', () {
    test('Should call Save Secure with correct values', () async {
      await sut.saveSecure(key: key, value: value);

      verify(secureStorage.write(key: key, value: value)).called(1);
    });

    test('Should return left instance of ValueFailure', () async {
      mockSaveSecureWriteError();
      final result = await sut.saveSecure(key: key, value: value);
      expect(result, isA<Either<ValueFailure, Unit>>());
    });
  });

  group('fetchSecure', () {
    setUp(() {
      mockFetchSecure();
    });
    test('Should call Fetch Secure with correct values', () async {
      await sut.fetchSecure(key);

      verify(secureStorage.read(key: key)).called(1);
    });

    test('Should return correct value on success', () async {
      final fetchedValue = await sut.fetchSecure(key);

      expect(fetchedValue, value);
    });

    test('Should throw if FetchSecure throws', () async {
      mockFetchSecureError();
      final future = sut.fetchSecure(key);
      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}
