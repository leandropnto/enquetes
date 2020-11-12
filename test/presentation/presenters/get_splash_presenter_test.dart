import 'package:enquetes/domain/entities/entities.dart';
import 'package:enquetes/domain/usecases/usecases.dart';
import 'package:enquetes/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;
  final _navigateTo = RxString();

  GetxSplashPresenter({@required this.loadCurrentAccount});

  @override
  Future<void> checkAccount() async {
    try {
      final account = await loadCurrentAccount.load();
      navigate = account != null ? "/surveys" : "/login";
    } catch (e) {
      navigate = "/login";
    }
  }

  @override
  Stream<String> get navigateToStream => _navigateTo.stream;

  set navigate(String value) => _navigateTo.value = value;
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  //Variables
  LoadCurrentAccount loadCurrentAccount;
  GetxSplashPresenter sut;
  //Mocks
  void mockLoadAccount(AccountEntity accountEntity) {
    when(loadCurrentAccount.load()).thenAnswer((_) async => accountEntity);
  }

  void mockLoadAccountError() {
    when(loadCurrentAccount.load()).thenThrow((_) => Exception());
  }
  //helpers

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadAccount(AccountEntity(faker.guid.guid()));
  });

  test('Should call loadCurrent account', () async {
    await sut.checkAccount();
    verify(loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream
        .listen(expectAsync1((value) => expect(value, "/surveys")));
    await sut.checkAccount();
  });

  test('Should go to login page on null result', () async {
    mockLoadAccount(null);
    sut.navigateToStream
        .listen(expectAsync1((value) => expect(value, "/login")));
    await sut.checkAccount();
  });

  test('Should go to login page on null result', () async {
    mockLoadAccountError();
    sut.navigateToStream
        .listen(expectAsync1((value) => expect(value, "/login")));
    await sut.checkAccount();
  });
}
