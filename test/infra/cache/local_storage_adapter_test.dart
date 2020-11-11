import 'package:enquetes/infra/cache/cache.dart';
import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  //Variables
  LocalStorageAdapter sut;
  FlutterSecureStorage secureStorage;
  String value;
  String key;
  //Mocks
  void mockSaveSecureWriteError() {
    when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());
  }
  //helpers

  //setup
  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('saveSecure', () {
    test('Should call Save Secure with correct values', () async {
      await sut.saveSecure(key: key, value: value);

      verify(secureStorage.write(key: key, value: value)).called(1);
    });

    test('Should throw is Save Secure throws', () async {
      mockSaveSecureWriteError();
      final future = sut.saveSecure(key: key, value: value);
      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetchSecure', () {
    test('Should call Fetch Secure with correct values', () async {
      await sut.fetchSecure(key);

      verify(secureStorage.read(key: key)).called(1);
    });
  });
}
