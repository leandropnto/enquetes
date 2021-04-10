import 'package:enquetes/domain/entities/entities.dart';
import 'package:enquetes/domain/usecases/usecases.dart';
import 'package:enquetes/presentation/presenters/presenters.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  //Variables
  LoadCurrentAccount loadCurrentAccount = LoadCurrentAccountSpy();
  GetxSplashPresenter sut =
      GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
  //Mocks
  void mockLoadAccount(AccountEntity? accountEntity) {
    when(loadCurrentAccount.load()).thenAnswer((_) async => accountEntity);
  }

  void mockLoadAccountError() {
    when(loadCurrentAccount.load()).thenThrow((_) => Exception());
  }
  //helpers

  setUp(() {
    mockLoadAccount(AccountEntity(Token.of(faker.guid.guid())));
  });

  test('Should call loadCurrent account', () async {
    await sut.checkAccount(durationInSeconds: 0);
    verify(loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on success', () async {
    sut.navigateToStream
        .listen(expectAsync1((value) => expect(value, "/surveys")));
    await sut.checkAccount(durationInSeconds: 0);
  });

  test('Should go to login page on null result', () async {
    mockLoadAccount(null);
    sut.navigateToStream
        .listen(expectAsync1((value) => expect(value, "/login")));
    await sut.checkAccount(durationInSeconds: 0);
  });

  test('Should go to login page on null result', () async {
    mockLoadAccountError();
    sut.navigateToStream
        .listen(expectAsync1((value) => expect(value, "/login")));
    await sut.checkAccount(durationInSeconds: 0);
  });
}
