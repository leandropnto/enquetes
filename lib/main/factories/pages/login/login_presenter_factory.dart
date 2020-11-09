import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/login/login_presenter.dart';
import '../../usecases/authentication_factory.dart';
import 'login.dart';

LoginPresenter makeStreamLoginPresenter() => StreamLoginPresenter(
      authentication: makeRemoteAuthentication(),
      validation: makeLoginValidation(),
    );

LoginPresenter makeGetxLoginPresenter() => GetxLoginPresenter(
      authentication: makeRemoteAuthentication(),
      validation: makeLoginValidation(),
    );
