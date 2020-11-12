import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

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
