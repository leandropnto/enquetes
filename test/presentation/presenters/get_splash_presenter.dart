import 'package:enquetes/domain/entities/entities.dart';
import 'package:enquetes/domain/usecases/usecases.dart';
import 'package:enquetes/ui/pages/pages.dart';
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
    await loadCurrentAccount.load();
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
  void mockLoadAccount() {
    when(loadCurrentAccount.load()).thenAnswer((_) async => AccountEntity(any));
  }

  //helpers

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
  });

  test('Should call loadCurrent account', () async {
    await sut.checkAccount();
    verify(loadCurrentAccount.load()).called(1);
  });
}
