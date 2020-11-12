import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../usecases/usecases.dart';

SplashPresenter makeGetxSplashPresenter() =>
    GetxSplashPresenter(loadCurrentAccount: makeLocalLoadCurrentAccount());
