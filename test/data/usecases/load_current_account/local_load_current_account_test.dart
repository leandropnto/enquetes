import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

abstract class FetchSecureCacheStorage {
  Future<void> fetchSecure(String key) async {}
}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

class LocalLoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({this.fetchSecureCacheStorage});

  Future<void> load() async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}

void main() {
  //Variables
  LocalLoadCurrentAccount sut;
  FetchSecureCacheStorage fetchSecureCacheStorage;
  //Mocks

  //helpers

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
        fetchSecureCacheStorage: fetchSecureCacheStorage);
  });

  test('Should call FetchSecureCacheStorage with correct value ', () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });
}
