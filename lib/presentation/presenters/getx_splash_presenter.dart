import 'package:get/get.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;
  final _navigateTo = RxString("");

  GetxSplashPresenter({required this.loadCurrentAccount});

  @override
  Future<void> checkAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      final account = await loadCurrentAccount.load();
      navigate = account != null ? "/surveys" : "/login";
    } catch (e) {
      navigate = "/login";
    }
  }

  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;

  set navigate(String value) => _navigateTo.value = value;
}
